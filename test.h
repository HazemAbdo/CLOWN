#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <vector>

using std::map;
using std::string;
using std::vector;

static int scope = 0;

/* Structure to represent a symbol entry in the table */
typedef struct SymbolEntry
{
    int dataType;
    char *name;
    int symbolType;
    int scope;
    bool used;
    bool initialized;
    SymbolEntry(int dataType, char *name, int symbolType, int scope, bool initialized)
    {
        this->name = name;
        this->symbolType = symbolType;
        this->scope = scope;
        this->used = false;
        this->initialized = initialized;
    }
} SymbolEntry;

static map<string, SymbolEntry *> symbolTable;

// Function to add a symbol entry to the symbol table
void addSymbolEntry(int dataType, char *name, int symbolType, int isInitialized)
{
    // Check if the name is null
    if (name == NULL)
    {
        fprintf(stderr, "Name is null.\n");
        return;
    }

    // Check if the name already exists in the current scope
    if (symbolTable.find(name) != symbolTable.end() && symbolTable[name]->scope == scope)
    {
        return;
    }

    // Create a new symbol entry by using the constructor
    SymbolEntry *entry = new SymbolEntry(name, symbolType, scope, (bool)isInitialized);

    // Add the symbol entry to the symbol table
    symbolTable[name] = entry;
}

// Function to free the memory allocated to the symbol table
void freeSymbolTable()
{
    for (auto it = symbolTable.begin(); it != symbolTable.end(); it++)
    {
        free(it->second->name);
        free(it->second);
    }
}

// Function to write the symbol table to a file
void writeSymbolTable(char *filename = "outputs/symbol_table.txt")
{
    // Open the file for writing
    FILE *fp = fopen(filename, "w");
    if (fp == NULL)
    {
        fprintf(stderr, "Failed to open file '%s' for writing.\n", filename);
        return;
    }

    fprintf(fp, "Name,SymbolType,Scope,Used,Initialized\n");

    // Iterate over all the symbol entries in the symbol table
    for (auto it = symbolTable.begin(); it != symbolTable.end(); it++)
    {
        // Get the symbol entry
        SymbolEntry *entry = it->second;

        // Write the symbol entry to the file
        fprintf(fp, "%s,%d,%d,%d,%d\n", entry->name, entry->symbolType, entry->scope, entry->used, entry->initialized);
    }

    // Close the file
    fclose(fp);
}