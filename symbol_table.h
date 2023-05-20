#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define a structure to represent a symbol
typedef struct symbol
{
    char *name;
    char *type;
    int isConst;
    char *value;
    int isInitialized;
} symbol_t;

// Define a structure to represent the symbol table
typedef struct symbol_table
{
    symbol_t **symbols;
    int size;
    struct symbol_table *parent;
} symbol_table_t;

typedef struct symbol_table_stack
{
    symbol_table_t **tables;
    int size;
} symbol_table_stack_t;

// Initialize a new symbol table
symbol_table_t *initSymbolTable()
{
    printf("Initializing symbol table\n");
    symbol_table_t *table = malloc(sizeof(symbol_table_t));
    table->symbols = NULL;
    table->size = 0;
    table->parent = NULL;
    return table;
}

// Initialize a new symbol table stack
symbol_table_stack_t *initSymbolTableStack(symbol_table_t *table)
{
    printf("Initializing symbol table stack\n");
    symbol_table_stack_t *stack = malloc(sizeof(symbol_table_stack_t));
    stack->tables = malloc(sizeof(symbol_table_t *));
    stack->tables[0] = table;
    stack->size = 1;

    return stack;
}

// Add a new symbol to the symbol table
void addSymbol(symbol_table_t *table, char *name, char *type, int isConst, char *value)
{
    // print current stack size
    printf("Table size before add: %d\n", table->size);
    if (isConst == 1)
    {
        printf("Adding constant %s to symbol table\n", name);
    }
    else
    {
        printf("Adding variable %s to symbol table\n", name);
    }
    symbol_t *sym = malloc(sizeof(symbol_t));
    sym->name = strdup(name);
    sym->type = strdup(type);
    sym->isConst = isConst;
    printf("value: %s\n", value);
    // Check if value has the correct type
    if (value != NULL)
    {
        if (strcmp(sym->type, "int") == 0 && atoi(value) == 0)
        {
            fprintf(stderr, "Error: value for variable %s is not of type int\n", name);
            exit(EXIT_FAILURE);
        }
        else if (strcmp(sym->type, "float") == 0 && atof(value) == 0)
        {
            fprintf(stderr, "Error: value for variable %s is not of type float\n", name);
            exit(EXIT_FAILURE);
        }
        else if (strcmp(sym->type, "String") == 0 && strlen(value) > 1)
        {
            fprintf(stderr, "Error: value for variable %s is not of type char\n", name);
            exit(EXIT_FAILURE);
        }
        else if (strcmp(sym->type, "bool") == 0 && (strcmp(value, "true") != 0 || strcmp(value, "false") != 0))
        {
            fprintf(stderr, "Error: value for variable %s is not of type bool\n", name);
            exit(EXIT_FAILURE);
        }
        else if (strcmp(sym->type, "void") == 0 && value != NULL)
        {
            fprintf(stderr, "Error: value for variable %s is not of type void\n", name);
            exit(EXIT_FAILURE);
        }
    }

    sym->value = value;
    if (sym->value == NULL)
    {
        sym->isInitialized = 0;
    }
    else
    {
        sym->isInitialized = 1;
    }
    // check if symbol already exists
    int i;
    for (i = 0; i < table->size; i++)
    {
        if (strcmp(table->symbols[i]->name, name) == 0)
        {
            fprintf(stderr, "Error: redeclaration of variable %s\n", name);
            exit(EXIT_FAILURE);
        }
    }

    table->size++;
    table->symbols = realloc(table->symbols, table->size * sizeof(symbol_t *));
    table->symbols[table->size - 1] = sym;
    printf("Table size after add: %d\n", table->size);
}

void unInitalized_variables(symbol_table_t *table)
{
    int i;
    for (i = 0; i < table->size; i++)
    {
        if (table->symbols[i]->isInitialized == 0)
        {
            fprintf(stderr, "Error: variable %s is not initialized\n", table->symbols[i]->name);
            exit(EXIT_FAILURE);
        }
    }
}

// Update the value of an existing symbol in the symbol table
void updateSymbol(symbol_table_t *table, char *name, char *value)
{
    int i;

    for (i = 0; i < table->size; i++)
    {
        if (strcmp(table->symbols[i]->name, name) == 0)
        {
            if (table->symbols[i]->isConst == 1)
            {
                fprintf(stderr, "Error: cannot update value of constant %s\n", name);
                exit(EXIT_FAILURE);
            }
            table->symbols[i]->value = value;
            table->symbols[i]->isInitialized = 1;
            return;
        }
    }
    fprintf(stderr, "Error: undeclared variable %s \n", name);
    exit(EXIT_FAILURE);
}

void printSymbolTable(symbol_table_t *table)
{
    FILE *fp;
    fp = fopen("symbol_table.csv", "a");
    // print it to external file
    fprintf(fp, "======\n");
    fprintf(fp, "Symbol Table\n");
    fprintf(fp, "Name,Type,Const,Value,Initialized\n");
    int i;
    for (i = 0; i < table->size; i++)
    {
        fprintf(fp, "%s,%s,%d,%s,%d\n", table->symbols[i]->name, table->symbols[i]->type, table->symbols[i]->isConst, table->symbols[i]->value, table->symbols[i]->isInitialized);
    }
    fclose(fp);
}

// Lookup a symbol in the symbol table and return its value
char *lookupSymbol(symbol_table_stack_t *stack, char *name)
{
    int i;
    for (i = stack->size - 1; i >= 0; i--)
    {
        symbol_table_t *table = stack->tables[i];
        int j;
        for (j = 0; j < table->size; j++)
        {
            if (strcmp(table->symbols[j]->name, name) == 0)
            {
                return table->symbols[j]->value;
            }
        }
    }
    fprintf(stderr, "Error: symbol %s not found in symbol table\n", name);
    exit(EXIT_FAILURE);
}

// Push a new symbol table onto the top of the stack
symbol_table_t *pushSymbolTable(symbol_table_stack_t *stack)
{
    stack->size++;
    stack->tables = realloc(stack->tables, stack->size * sizeof(symbol_table_t *));
    // create new table and return it
    symbol_table_t *symbolTable = initSymbolTable();
    stack->tables[stack->size - 1] = symbolTable;
    return symbolTable;
}

// Pop the topmost symbol table from the stack
symbol_table_t *popSymbolTable(symbol_table_stack_t *stack)
{
    if (stack->size == 0)
    {
        fprintf(stderr, "Error: symbol table stack underflow\n");
        exit(EXIT_FAILURE);
    }
    symbol_table_t *table = stack->tables[stack->size - 1];
    stack->size--;
    stack->tables = realloc(stack->tables, stack->size * sizeof(symbol_table_t *));

    // write the symbol table to external file
    printSymbolTable(table);

    return stack->tables[stack->size - 1];
}

void printSymbolTableStack(symbol_table_stack_t *stack)
{
    int i;
    for (i = 0; i < stack->size; i++)
    {
        printf("Symbol table %d\n", i);
        printSymbolTable(stack->tables[i]);
    }
}

// Free the memory used by the symbol table
void freeSymbolTable(symbol_table_t *table)
{
    printf("Freeing symbol table\n");
    int i;
    for (i = 0; i < table->size; i++)
    {
        free(table->symbols[i]->name);
        free(table->symbols[i]->type);
        free(table->symbols[i]);
    }
    free(table->symbols);
    free(table);
}