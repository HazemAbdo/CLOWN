#include <stdio.h>

/* Structure to represent a symbol entry in the table */
typedef struct
{
    char name[500];
    int tokenType;
} SymbolEntry;

/* Function to add a symbol entry to the symbol table */
void addSymbolEntry(const char *name, int tokenType)
{
    printf("Adding symbol entry: Name=%s, TokenType=%d\n", name, tokenType);
    SymbolEntry entry;
    strcpy(entry.name, name);
    entry.tokenType = tokenType;

    /* You can perform further operations here, such as storing the entry in a data structure. */

    printf("Added symbol entry: Name=%s, TokenType=%d\n", entry.name, entry.tokenType);
}