#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno;
extern int line_no;

char *switchCaseVariable = NULL;

int ifConditionsCount = 0;

int currentLoopScope = 0;
int loopsStack[1000];

int quadsStackTop = 0;
char quadsStack[1000][20];

int quadsCount = 0;
char quads[1000][100];

int registersCount = 0;

int labelsCount = 0;
int labelsStackTop = 0;
char labelsStack[1000][20];

//-------------------------------------------------------------------------------
// Quadruple functions
//-------------------------------------------------------------------------------
void pushQuad(char *val, int addToQuads)
{
    strcpy(quadsStack[quadsStackTop++], val);
    if (addToQuads == 1)
    {
        sprintf(quads[quadsCount++], "PUSH %s", val);
    }
}

void popQuad(char *dst)
{
    --quadsStackTop;
    sprintf(quads[quadsCount++], "POP %s", dst);
}

void oneOperandQuad(char *opr)
{
    char *op1 = strdup(quadsStack[quadsStackTop - 1]);

    --quadsStackTop; // pop wihtout creating quad

    char tempRegister[10];
    sprintf(tempRegister, "R%d", registersCount++);
    strcpy(quadsStack[quadsStackTop++], tempRegister);

    if (strcmp(opr, "!") == 0)
        sprintf(quads[quadsCount++], "NOT %s, %s", op1, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "-") == 0)
        sprintf(quads[quadsCount++], "NEG %s, %s", op1, quadsStack[quadsStackTop - 1]);
}

void twoOperandsQuad(char *opr)
{
    char *op1 = strdup(quadsStack[quadsStackTop - 2]);
    char *op2 = strdup(quadsStack[quadsStackTop - 1]);

    --quadsStackTop; // pop wihtout creating quad
    --quadsStackTop; // pop wihtout creating quad

    char tempRegister[10];
    sprintf(tempRegister, "R%d", registersCount++);
    strcpy(quadsStack[quadsStackTop++], tempRegister);

    if (strcmp(opr, "+") == 0)
        sprintf(quads[quadsCount++], "ADD %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "-") == 0)
        sprintf(quads[quadsCount++], "SUB %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "*") == 0)
        sprintf(quads[quadsCount++], "MUL %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "/") == 0)
        sprintf(quads[quadsCount++], "DIV %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "%") == 0)
        sprintf(quads[quadsCount++], "MOD %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "<") == 0)
        sprintf(quads[quadsCount++], "LT %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, ">") == 0)
        sprintf(quads[quadsCount++], "GT %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "^") == 0)
        sprintf(quads[quadsCount++], "XOR %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "<=") == 0)
        sprintf(quads[quadsCount++], "LE %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, ">=") == 0)
        sprintf(quads[quadsCount++], "GE %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "==") == 0)
        sprintf(quads[quadsCount++], "EQ %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "!=") == 0)
        sprintf(quads[quadsCount++], "NE %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "&&") == 0)
        sprintf(quads[quadsCount++], "AND %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
    else if (strcmp(opr, "||") == 0)
        sprintf(quads[quadsCount++], "OR %s, %s, %s", op1, op2, quadsStack[quadsStackTop - 1]);
}

void printQuadruples()
{
    FILE *f = fopen("outputs/quads.txt", "w");
    if (f == NULL)
    {
        printf("Error opening outputs/quads.txt file!\n");
        exit(1);
    }

    for (int i = 0; i < quadsCount; i++)
    {
        fprintf(f, "%s\n", quads[i]);
    }

    fclose(f);
}

//-------------------------------------------------------------------------------
// Label functions
//-------------------------------------------------------------------------------
void addLabel()
{
    char tempLabel[10];
    sprintf(tempLabel, "L%d", ++labelsCount);
    strcpy(labelsStack[labelsStackTop++], tempLabel);
}

void popLabels(int num)
{
    labelsStackTop -= num;
}

void printLabel(int addLabelFlag, int labelOffset)
{
    if (addLabelFlag == 1)
    {
        addLabel();
    }

    if (labelOffset == -1)
    {
        sprintf(quads[quadsCount++], "%s:", labelsStack[labelsStackTop - labelOffset]);
    }
    else
    {
        sprintf(quads[quadsCount++], "%s:", labelsStack[labelsStackTop - labelOffset]);
    }
}

void openLoop()
{
    loopsStack[++currentLoopScope] = loopsStack[currentLoopScope - 1] + 1;
}

void closeLoop()
{
    sprintf(quads[quadsCount++], "B%d:", loopsStack[currentLoopScope]);
}

void JZ(int addLabelFlag)
{
    if (addLabelFlag == 1)
    {
        addLabel();
    }

    sprintf(quads[quadsCount++], "JZ %s", labelsStack[labelsStackTop - 1]);
}

void JMP(int addLabelFlag, int labelOffset)
{
    if (addLabelFlag == 1)
    {
        addLabel();
    }

    if (labelOffset == -1)
    {
        sprintf(quads[quadsCount++], "JMP %s", labelsStack[0]);
    }
    else
    {
        sprintf(quads[quadsCount++], "JMP %s", labelsStack[labelsStackTop - labelOffset]);
    }
}

void BREAK_JMP()
{
    sprintf(quads[quadsCount++], "JMP B%d", loopsStack[currentLoopScope - 1]);
}