#include <stdio.h>
#include <stdarg.h>
#include <vector>
#include "structs.h"
#include "build/parser.tab.h"
#include <sstream>

using std::vector;

static int lbl, timestep = 0, lvl = 0;
static vector<SymbolEntry *> printableSymbolTable;
Node *constructLabelNode(int value);

void getUnusedVariables()
{
  std::map<std::string, SymbolEntry *>::iterator it;
  std::string str = "";

  for (it = sym[lvl].begin(); it != sym[lvl].end(); it++)
  {
    if (it->second->used == false)
    {
      str += it->second->name + " ";
    }
  }

  if (str.length() > 0)
    yyerror(("Error: Unused Variable(s) " + str + "\n").c_str());
}

SymbolEntry *getIdentifier(Node *p, bool isRHS = false)
{
  if (p->type != IDENTIFIER)
    return NULL;
  if (p->id.dataType != -1)
  {
    return NULL;
  }
  for (int i = lvl; i >= 0; i--)
  { // assignment statement
    if (sym[i].find(p->id.name) != sym[i].end())
    {
      SymbolEntry *entry = sym[i][p->id.name];
      if (isRHS && entry->symbolType == CONST)
      {
        char msg[1024];
        sprintf(msg, "Error: Cannot assign value to constant Identifier '%s'", p->id.name);
        yyerror(msg);
        return NULL;
      }
      if (!isRHS && entry->isInitialized == false)
      {
        char msg[1024];
        sprintf(msg, "Error: Usage of uninitialized identifier '%s'", p->id.name);
        yyerror(msg);
        return NULL;
      }
      sym[i][p->id.name]->used = true;
      return sym[i][p->id.name];
    }
  }

  char msg[1024];
  sprintf(msg, "Error: Undefined identifier '%s'", p->id.name);
  yyerror(msg);
  return NULL;
}

SymbolEntry *declareIdentifier(Node *p, bool isRHS = false)
{
  if (p->type != IDENTIFIER)
    return NULL;
  if (p->id.dataType == -1)
  {
    return getIdentifier(p, isRHS);
  }

  if (sym[lvl].count(p->id.name))
  {
    char msg[1024];
    sprintf(msg, "Error: Identifier '%s' already declared", p->id.name);
    yyerror(msg);
    return NULL;
  }
  sym[lvl][p->id.name] = new SymbolEntry(strdup(p->id.name), p->id.dataType, p->id.qualifier, lvl, timestep++, false);
  printableSymbolTable.push_back(sym[lvl][p->id.name]);
  return sym[lvl][p->id.name];
}

void addBlockLevel()
{
  sym.push_back(map<string, SymbolEntry *>());
  lvl++;
}
void removeBlockLevel()
{
  getUnusedVariables();
  sym.pop_back();
  lvl--;
}

int exec(Node *p, int continueLabel = -1, int breakLabel = -1, int args = 0, ...)
{
  va_list ap;
  int lbl1, lbl2, lbl3, resultType, resultType2;
  Node *lblNode;
  SymbolEntry *symbolEntry = NULL;

  vector<Node *> argsVector;
  va_start(ap, args);
  for (int i = 0; i < args; i++)
    argsVector.push_back(va_arg(ap, Node *));
  va_end(ap);
  if (!p)
    return 0;
  switch (p->type)
  {
  case CONSTANT:
    switch (p->con.dataType)
    {
    case TYPE_INT:
      printf("\tpush %s\t%d\n", getDataType(TYPE_INT), p->con.value.valInt);
      return TYPE_INT;
    case TYPE_BOOL:
      printf("\tpush %s\t%s\n", getDataType(TYPE_BOOL), p->con.value.valBool ? "true" : "false");
      return TYPE_BOOL;
    case TYPE_FLOAT:
      printf("\tpush %s\t%f\n", getDataType(TYPE_FLOAT), p->con.value.valFloat);
      return TYPE_FLOAT;
    }
    break;
  case IDENTIFIER:
    symbolEntry = getIdentifier(p); // usage of identifier (calling it)
    if (symbolEntry == NULL)
      return 0;
    printf("\tpush\t%s\n", p->id.name);
    return symbolEntry->type;
  case OPERATION:
    switch (p->opr.symbol)
    {
    case WHILE:
      addBlockLevel();
      printf("L%03d:\n", lbl1 = lbl++);
      resultType = exec(p->opr.p_operands[0]); // expression
      if (resultType != TYPE_BOOL)
      {
        yyerror("Error: While condition must be of type bool");
      }
      printf("\tjz\tL%03d\n", lbl2);
      exec(p->opr.p_operands[1], lbl1, lbl2);
      printf("\tjmp\tL%03d\n", lbl1);
      printf("L%03d:\n", lbl2);
      removeBlockLevel();
      break;
    case FOR:
      addBlockLevel();
      exec(p->opr.p_operands[0]); // declaration / initialization
      printf("L%03d:\n", lbl1 = lbl++);

      resultType = exec(p->opr.p_operands[1]); // expression (condition)
      if (resultType != TYPE_BOOL)
      {
        yyerror("Error: For condition must be of type bool");
      }
      printf("\tjz\tL%03d\n", lbl2 = lbl++); // if condition not fullfilled jump

      exec(p->opr.p_operands[3], lbl3 = lbl++, lbl2); // statement

      printf("L%03d:\n", lbl3);   // label for continueing
      exec(p->opr.p_operands[2]); // assignment (increment/decrement)
      printf("\tjmp\tL%03d\n", lbl1);
      printf("L%03d:\n", lbl2);
      removeBlockLevel();
      break;
    case REPEAT:
      addBlockLevel();
      printf("L%03d:\n", lbl1 = lbl++);
      exec(p->opr.p_operands[0], lbl1, lbl2 = lbl++);
      resultType = exec(p->opr.p_operands[1]);
      if (resultType != TYPE_BOOL)
      {
        yyerror("Error: Repeat condition must be of type bool");
      }
      printf("\tjz\tL%03d\n", lbl1); // if condition not fullfilled repeat
      printf("L%03d:\n", lbl2);
      removeBlockLevel();
      break;
    case IF:
      addBlockLevel();
      resultType = exec(p->opr.p_operands[0]);
      if (resultType != TYPE_BOOL)
      {
        yyerror("Error: If condition must be of type bool");
      }
      if (p->opr.numberOfOperands > 2)
      {
        /* if else */
        printf("\tjz\tL%03d\n", lbl1 = lbl++);
        exec(p->opr.p_operands[1], continueLabel, breakLabel);
        printf("\tjmp\tL%03d\n", lbl2 = lbl++);
        printf("L%03d:\n", lbl1);
        exec(p->opr.p_operands[2], continueLabel, breakLabel);
        printf("L%03d:\n", lbl2);
      }
      else
      {
        /* if */
        printf("\tjz\tL%03d\n", lbl1 = lbl++);
        exec(p->opr.p_operands[1], continueLabel, breakLabel);
        printf("L%03d:\n", lbl1);
      }
      removeBlockLevel();
      break;
    case PRINT:
      exec(p->opr.p_operands[0], continueLabel, breakLabel);
      printf("\tprint\n");
      break;
    case '=':
      resultType = exec(p->opr.p_operands[1]);
      if (p->opr.p_operands[1]->type == OPERATION && p->opr.p_operands[1]->opr.symbol == '=')
      {
        printf("\tpush\t%s\n", p->opr.p_operands[1]->opr.p_operands[0]->id.name);
      }
      symbolEntry = declareIdentifier(p->opr.p_operands[0], true);
      if (resultType != symbolEntry->type)
      {
        char msg[1024];
        sprintf(msg, "Error: Type mismatch in assignment %s and '%s' %s",
                getDataType(resultType),
                p->opr.p_operands[0]->id.name,
                getDataType(symbolEntry->type));
        yyerror(msg);
      }
      symbolEntry->isInitialized = true;
      printf("\tpop %s\t%s\n", getDataType(symbolEntry->type), p->opr.p_operands[0]->id.name);
      return symbolEntry->type;
    case DECLARE:
      declareIdentifier(p->opr.p_operands[0], true);
      printf("\tpop %s\t%s\n", getDataType(p->opr.p_operands[0]->id.dataType), p->opr.p_operands[0]->id.name);
      break;
    case UMINUS:
      resultType = exec(p->opr.p_operands[0]);
      printf("\tneg\n");
      return resultType;
    case NOT:
      resultType = exec(p->opr.p_operands[0]);
      printf("\tnot\n");
      return TYPE_BOOL;
    case SWITCH:
      symbolEntry = getIdentifier(p->opr.p_operands[0]);
      if (symbolEntry->type != TYPE_INT && symbolEntry->type != TYPE_BOOL)
      {
        yyerror("SWITCH Variable must be an integer or boolean");
      }
      addBlockLevel();
      lbl1 = lbl++;
      exec(p->opr.p_operands[1], -1, lbl1, 1, p->opr.p_operands[0]);
      printf("L%03d:\n", lbl1);
      removeBlockLevel();
      break;
    case SWITCH_BODY:
      for (int i = 0; i < p->opr.numberOfOperands; i++)
        exec(p->opr.p_operands[i], continueLabel, breakLabel, 1, argsVector[0]);
      break;
    case CASE:
      addBlockLevel();
      symbolEntry = getIdentifier(argsVector[0]);
      if (symbolEntry->type != p->opr.p_operands[0]->con.dataType)
      {
        char msg[1024];
        sprintf(msg, "case value (%s) and switch '%s' (%s) type mismatch",
                getDataType(p->opr.p_operands[0]->con.dataType), symbolEntry->name.c_str(), getDataType(symbolEntry->type));
        yyerror(msg);
      }
      exec(argsVector[0]);        // the variable
      exec(p->opr.p_operands[0]); // the constant
      printf("\tcompEQ\n");
      printf("\tjz\tL%03d\n", lbl1 = lbl++); // if condition not fullfilled jump
      if (argsVector.size() > 1)             // after-condition label
        printf("L%03d:\n", argsVector[1]->con.value);
      exec(p->opr.p_operands[1], continueLabel, breakLabel); // execute statements
      // exec(p->opr.p_operands[2], continueLabel, breakLabel, 1, argsVector[0]); // break (if exists)
      // skip next conditions until you find break only if there's a next case
      // ow it is the default case
      if (p->opr.p_operands[2]->type == OPERATION && p->opr.p_operands[2]->opr.symbol == CASE)
        printf("\tjmp\tL%03d\n", lbl2 = lbl++);
      printf("L%03d:\n", lbl1); // next case label
      lblNode = constructLabelNode(lbl2);
      exec(p->opr.p_operands[2], continueLabel, breakLabel, 2, argsVector[0], lblNode); // next case
      removeBlockLevel();
      break;
    case BREAK:
      if (breakLabel == -1)
      {
        yyerror("Error: break cannot outside of loop or switch");
        break;
      }
      printf("\tjmp\tL%03d\n", breakLabel);
      break;
    case CONTINUE:
      if (continueLabel == -1)
      {
        yyerror("Error: continue cannot be outside of loop");
        break;
      }
      printf("\tjmp\tL%03d\n", continueLabel);
    case DEFAULT:
      addBlockLevel();
      exec(p->opr.p_operands[0], continueLabel, breakLabel);
      removeBlockLevel();
      break;
    case BLOCK:
      addBlockLevel();
      for (int i = 0; i < p->opr.numberOfOperands; i++)
        exec(p->opr.p_operands[i], continueLabel, breakLabel);
      removeBlockLevel();
      break;
    case ';':
      for (int i = 0; i < p->opr.numberOfOperands; i++)
        exec(p->opr.p_operands[i], continueLabel, breakLabel);
      break;
    default:
      resultType = exec(p->opr.p_operands[0], continueLabel, breakLabel);
      resultType2 = exec(p->opr.p_operands[1], continueLabel, breakLabel);
      if (resultType != resultType2)
      {
        char msg[1024];
        sprintf(msg, "Error: Type mismatch in operand1 %s and operand2 %s",
                getDataType(resultType),
                getDataType(resultType2));
        yyerror(msg);
      }
      switch (p->opr.symbol)
      {
      case '+':
        printf("\tadd\n");
        return resultType;
      case '-':
        printf("\tsub\n");
        return resultType;
      case '*':
        printf("\tmul\n");
        return resultType;
      case '/':
        printf("\tdiv\n");
        return resultType;
      case '<':
        printf("\tcompLT\n");
        return TYPE_BOOL;
      case '>':
        printf("\tcompGT\n");
        return TYPE_BOOL;
      case GE:
        printf("\tcompGE\n");
        return TYPE_BOOL;
      case LE:
        printf("\tcompLE\n");
        return TYPE_BOOL;
      case NE:
        printf("\tcompNE\n");
        return TYPE_BOOL;
      case EQ:
        printf("\tcompEQ\n");
        return TYPE_BOOL;
      case AND:
        printf("\tand\n");
        return TYPE_BOOL;
      case OR:
        printf("\tor\n");
        return TYPE_BOOL;
      }
    }
  }
  return 0;
}

Node *constructLabelNode(int value)
{
  Node *p;
  size_t nodeSize;

  /* allocate Node */
  nodeSize = SIZEOF_NODETYPE + sizeof(ConstantNode);
  if ((p = (Node *)malloc(nodeSize)) == NULL)
    yyerror("out of memory");

  /* copy information */
  p->type = CONSTANT;
  p->con.value.valInt = value;
  return p;
}

void exportSymbolTable()
{
  FILE *fp;
  SymbolEntry *p;
  int i;

  if ((fp = fopen(".\\outputs\\symbolTable.txt", "w")) == NULL)
    yyerror("cannot open symbolTable.txt");
  fprintf(fp, "Time Step,Name,Data Type,Qualifier,Scope\n");
  for (i = 0; i < printableSymbolTable.size(); i++)
  {
    p = printableSymbolTable[i];
    fprintf(fp, "%d,%s,%s,%s,%d\n", p->timestamp, p->name.c_str(), getDataType(p->type),
            p->symbolType == CONST ? "Constant" : "Variable", p->scope);
    free(p);
  }
  fclose(fp);
}