/* ------------------------------------------------------------------------------------------------------------------------------------------
 Program: output.c
 Author: Ugo-Michael Onuke
 Purpose Of Code:   Voice recognition. Write a program to examine files and predict whether the file is "yes" or a "no".
                    The program works off the basic principal that as any graph crosses the x-axis, the 'y' value changes sign.
                    The program counts the number of times this event happens and uses the number of crossings to decide which file is what.
 ------------------------------------------------------------------------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>

int main()
{
    system("color F9");
    FILE* ip_file;
    int count=0, i, y=0, z=0, j=0, n=0, c;
    double a, b;
    printf("Please choose which file you wish to examine...\n\n1 = FILE yes.txt\n\n2 = FILE no.txt\n\n");
    scanf("%d", &c); // File selector.
    char fileEnd;
    if(c == 1) // File selector.
    {
        ip_file = fopen("yes.txt", "r"); // File opened.
        system("cls"); // Clear user screen to show wanted data.
        printf("The file you have selected is 'yes.txt'.\n");
    }
    if(c == 2) // File selector.
    {
        ip_file = fopen("no.txt", "r"); // File opened.
        system("cls"); // Clear user screen to show wanted data.
        printf("The file you have selected is 'no.txt'.\n");
    }
    double dummy;
    if(ip_file != NULL) // If the program finds the file, then it will proceed.
    {
        for ( ;fileEnd != EOF; ) // Program scans to the end of file.
        {
            fscanf(ip_file, "%lf", &dummy);
            n++; // Program counts the size of file.
            fileEnd = fgetc(ip_file);
        }
        fclose(ip_file); // The program has reached the end of file.
    }
    if(c == 1)
    {
        ip_file = fopen("yes.txt", "r"); // Program reopens the file for examination.
    }
    if(c == 2)
    {
        ip_file = fopen("no.txt", "r"); // Program reopens the file for examination.
    }
    double data[n];
    if (ip_file != NULL) // If the program finds the file, then it will proceed.
    {
        fscanf(ip_file,"%lf", &data[0]); // Scan in data[0].
        while(data[0] == 0)
        {
            fscanf(ip_file,"%lf", &data[0]); // While data[0] = 0, scan in a new data.
        }
        a=data[0]; // First element in file.
        for(i=1; (!feof(ip_file)); i++) // i will continue to increase till the end of data.
        {
            fscanf(ip_file,"%lf", &data[i]); // Scan in data[1].
            while(data[i] == 0)
            {
                i++;
                fscanf(ip_file,"%lf", &data[i]); // While data[1] = 0, scan in a new data.
            }
            b=data[i];
            if((a*b)<0) // Test if the graph crosses x-axis.
            {
                count++;
            }
            a=b; // 'a' is overwritten to be 'b' and then the loop fires agian looking for a new b.
        }
    }
    else
    {
        printf("No file found!"); // Program informs the user if no file is found.
    }
    fclose(ip_file); // The program has reached the end of file.
    printf("\nThe number of x-axis crosses are %d.\n", count);
    if(count>=1000) // The program now decides whether the file is a Yes.
    {
        printf("\nVoice recognised as Yes!\n"); // Program informs the user if voice is recognised as a Yes.
    }
    if(count<1000) // The program now decides whether the file is a No.
    {
        printf("\nVoice recognised as No!\n"); // Program informs the user if voice is recognised as a No.
    }
    return 0;
}
