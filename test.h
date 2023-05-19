#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <vector>

using std::map;
using std::string;
using std::vector;

/* Structure to represent a symbol entry in the table */
typedef struct SymbolEntry
{
    char *name;
    int symbolType;
    int scope;
    bool used;
    bool initialized;
    SymbolEntry(char *name, int symbolType, int scope, bool initialized)
    {
        this->name = name;
        this->symbolType = symbolType;
        this->scope = scope;
        this->used = false;
        this->initialized = initialized;
    }
} SymbolEntry;

static vector<map<string, SymbolEntry *>> symbolTable(1, map<string, SymbolEntry *>());

// Function to add a symbol entry to the symbol table
void addSymbolEntry(char *name, int symbolType, int isInitialized)
{
    // Check if the name is null
    if (name == NULL)
    {
        fprintf(stderr, "Name is null.\n");
        return;
    }

    // Create a new symbol entry by using the constructor
    SymbolEntry *entry = new SymbolEntry(name, symbolType, 0, (bool)isInitialized);

    // Add the symbol entry to the symbol table
    map<string, SymbolEntry *> newSymbolEntry;
    newSymbolEntry[name] = entry;
    symbolTable.push_back(newSymbolEntry);
}

// Function to free the memory allocated to the symbol table
void freeSymbolTable()
{
    // Iterate over all the symbol entries in the symbol table
    for (int i = 0; i < symbolTable.size(); i++)
    {
        // Iterate over all the entries in the current symbol entry
        for (map<string, SymbolEntry *>::iterator it = symbolTable[i].begin(); it != symbolTable[i].end(); it++)
        {
            // Free the memory allocated to the symbol entry
            free(it->second->name);
            free(it->second);
        }
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
    for (int i = 0; i < symbolTable.size(); i++)
    {
        // Iterate over all the entries in the current symbol entry
        for (map<string, SymbolEntry *>::iterator it = symbolTable[i].begin(); it != symbolTable[i].end(); it++)
        {
            // Write the symbol entry to the file
            fprintf(fp, "%s,%d,%d,%d,%d\n", it->second->name, it->second->symbolType, it->second->scope, it->second->used, it->second->initialized);
        }
    }

    // Close the file
    fclose(fp);
}