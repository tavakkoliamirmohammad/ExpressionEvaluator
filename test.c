#include <string.h>
#include <stdio.h>
#include <stdlib.h>

char *number_mapping_token(int number) {
    switch (number) {
        case 0:
            return "Zer";
        case 1:
            return "One";
        case 2:
            return "Two";
        case 3:
            return "Thr";
        case 4:
            return "Fou";
        case 5:
            return "Fiv";
        case 6:
            return "Six";
        case 7:
            return "Sev";
        case 8:
            return "Eig";
        case 9:
            return "Nin";
        case 1000:
            return "Tou_";
        case 100:
            return "Hun_";
        case 10:
            return "Ten_";
    }
}


char *parse_number(int number) {
    char *translated = (char *) malloc(400 * sizeof(char));
    translated[0] = '\0';
    int division = 100;
    int is_digit_found = 0;
    while (1) {
        int upper_part;
        if (division == 0) {
            upper_part = number;
        } else {
            number = number % division;
        }
        if (upper_part != 0) {
            strcat(translated, number_mapping_token(upper_part));
            if (division != 0) {
                strcat(translated, number_mapping_token(division));
            }
            else{
                return translated;
            }
            number = number % division;
            division /= 10;
            is_digit_found = 1;
        }
        if (upper_part == 0) {
            if (is_digit_found) {
                strcat(translated, number_mapping_token(upper_part));
            } else {
                division /= 10;
            }
        }
    }
}


char *translate_number(int num) {
    printf("%d\n", num);

    int upper = num / 1000;
    int lower = num % 1000;
    char *translated = (char *) malloc(400 * sizeof(char));
    // when number is not zero
    char *up = parse_number(upper);
    printf("upper: %s\n", up);
    if(strlen(up) != 0){
        strcat(translated,"(");
        strcat(translated, up);
        strcat(translated, ")");
    }
    // printf("%s", upper && lower ? "_" : "");
    char *low = parse_number(lower);
    printf("lower: %s\n", low);
    strcat(translated, low);
    printf("%s\n", translated);
    return translated;
}

int main(){
    translate_number(0);
    translate_number(1);
    translate_number(10000);
    translate_number(1000);
    translate_number(100);
    translate_number(12925);
    translate_number(106);
    translate_number(5);
    translate_number(2840);
    translate_number(99999);
    translate_number(9999);

    return 0;
}