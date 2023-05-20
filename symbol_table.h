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
} symbol_t;

// Define a structure to represent the symbol table
typedef struct symbol_table
{
    symbol_t **symbols;
    int size;
} symbol_table_t;

// Initialize a new symbol table
symbol_table_t *initSymbolTable()
{
    printf("Initializing symbol table\n");
    symbol_table_t *table = malloc(sizeof(symbol_table_t));
    table->symbols = NULL;
    table->size = 0;
    return table;
}

// Add a new symbol to the symbol table
void addSymbol(symbol_table_t *table, char *name, char *type, int isConst, char *value)
{
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
    sym->value = value;
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
            return;
        }
    }
    fprintf(stderr, "Error: undeclared variable %s \n", name);
    exit(EXIT_FAILURE);
}

// Lookup a symbol in the symbol table and return its value
char *lookupSymbol(symbol_table_t *table, char *name)
{
    int i;
    for (i = 0; i < table->size; i++)
    {
        if (strcmp(table->symbols[i]->name, name) == 0)
        {
            return table->symbols[i]->value;
        }
    }
    fprintf(stderr, "Error: symbol %s not found in symbol table\n", name);
    exit(EXIT_FAILURE);
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