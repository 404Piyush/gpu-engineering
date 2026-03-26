#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define MAX_ACCOUNTS 5
#define MAX_HISTORY 10

typedef struct {
    char date[11];
    float amount;
    char type[10]; // "Deposit" or "Withdraw"
} Transaction;

typedef struct {
    int id;
    char name[25];
    float balance;
    Transaction history[MAX_HISTORY];
    int historyCount;
} Account;

// --- Function 1: Logs a transaction (Nested Struct) ---
void logTransaction(Account *acc, float amt, const char *type) {
    if (acc->historyCount < MAX_HISTORY) {
        int idx = acc->historyCount;
        acc->history[idx].amount = amt;
        strcpy(acc->history[idx].type, type);
        strcpy(acc->history[idx].date, "2026-03-26");
        acc->historyCount++;
    }
}

// --- Function 2: Core Logic for Deposits ---
bool deposit(Account *acc, float amount) {
    if (amount <= 0) return false;
    acc->balance += amount;
    logTransaction(acc, amount, "Deposit");
    return true;
}

// --- Function 3: Core Logic for Withdrawals ---
bool withdraw(Account *acc, float amount) {
    if (amount > acc->balance || amount <= 0) return false;
    acc->balance -= amount;
    logTransaction(acc, amount, "Withdraw");
    return true;
}

// --- Function 4: Deep Display (Iterating through nested structs) ---
void printStatement(Account acc) {
    printf("\n==================================\n");
    printf("Account: %-15s (ID: %d)\n", acc.name, acc.id);
    printf("Current Balance: $%.2f\n", acc.balance);
    printf("----------------------------------\n");
    printf("Recent Transactions:\n");
    for (int i = 0; i < acc.historyCount; i++) {
        printf(" [%s] %-10s: $%.2f\n", 
               acc.history[i].date, 
               acc.history[i].type, 
               acc.history[i].amount);
    }
    printf("==================================\n");
}

// --- Function 5: System Initializer ---
void initSystem(Account bank[], int *total) {
    char *names[] = {"Piyush", "Anil", "Innovision"};
    float starts[] = {5000.0, 1200.0, 25000.0};

    for (int i = 0; i < 3; i++) {
        bank[i].id = 1001 + i;
        strcpy(bank[i].name, names[i]);
        bank[i].balance = starts[i];
        bank[i].historyCount = 0;
        (*total)++;
    }
}

int main() {
    Account bank[MAX_ACCOUNTS];
    int activeAccounts = 0;

    printf("--- System Booting ---\n");
    initSystem(bank, &activeAccounts);

    // Simulate some real activity
    printf("Processing transactions...\n");
    
    // Piyush deposits and withdraws
    deposit(&bank[0], 1500.50);
    withdraw(&bank[0], 200.00);
    
    // Anil gets a large deposit
    deposit(&bank[1], 10000.00);
    
    // Innovision pays a bill
    withdraw(&bank[2], 5500.25);
    deposit(&bank[2], 1200.00);

    // Final Output
    for (int i = 0; i < activeAccounts; i++) {
        printStatement(bank[i]);
    }

    float totalLiquidity = 0;
    for (int i = 0; i < activeAccounts; i++) {
        totalLiquidity += bank[i].balance;
    }
    
    printf("\nBANK TOTAL LIQUIDITY: $%.2f\n", totalLiquidity);
    printf("--- System Shutdown ---\n");

    return 0;
}