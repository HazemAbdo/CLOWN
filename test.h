#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <vector>
#include <map>

using std::map;
using std::string;
using std::vector;

/* Structure to represent a symbol entry in the table */
typedef struct
{
    char *name;
    int tokenType;
    // Add any additional fields you need to store symbol information
} SymbolEntry;

static vector<map<string, SymbolEntry *>> symbolTable = vector<map<string, SymbolEntry *>>();

// Function to add a symbol entry to the symbol table
void addSymbolEntry(char *name, int tokenType)
{
    // Check if the name is null
    if (name == NULL)
    {
        fprintf(stderr, "Name is null.\n");
        return;
    }

    // Create a new symbol entry
    SymbolEntry *entry = (SymbolEntry *)malloc(sizeof(SymbolEntry));
    if (entry == NULL)
    {
        fprintf(stderr, "Failed to allocate memory for symbol entry.\n");
        return;
    }

    // Initialize the fields of the symbol entry
    entry->name = strdup(name); // Make a copy of the name string
    entry->tokenType = tokenType;

    // Add the symbol entry to the symbol table
    map<string, SymbolEntry *> currentScope;
    currentScope[name] = entry;          // Add the entry to the current scope
    symbolTable.push_back(currentScope); // Add the current scope to the symbol table

    // Print the added symbol entry (for demonstration purposes)
    printf("Added symbol entry: Name=%s, TokenType=%d\n", entry->name, entry->tokenType);
}

// Function to free the memory allocated to the symbol table
void freeSymbolTable()
{
    // Iterate over all the symbol entries in the symbol table
    for (int i = 0; i < symbolTable.size(); i++)
    {
        map<string, SymbolEntry *> currentScope = symbolTable[i];
        for (map<string, SymbolEntry *>::iterator it = currentScope.begin(); it != currentScope.end(); it++)
        {
            // Free the memory allocated to the symbol entry
            SymbolEntry *entry = it->second;
            free(entry->name);
            free(entry);
        }
    }
}