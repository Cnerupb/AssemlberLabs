// Online C++ compiler to run C++ program online
#include <iostream>

int main() {
    // Write C++ code here
    int a[3][3] = {
        {55, 12, 60},
        {12, 54, 23},
        {78, 99, 44}
    };
    
    int summa = 0;
    int max_summa = -1;
    int max_summa_i = -1;
    int min_summa = -1;
    int min_summa_i = -1;
    
    // Вектор
    // Хранит чередующиеся элементы из наибольшей и наименьшей подстроки
    int b[6];
    
    // Пробигаемся по матрице и находим строки с наибольшей, наименьшей суммой элементов строки
    // Запоминаем индексы таких строк
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            summa += a[i][j];
        }
        if (max_summa == -1) {
            max_summa = summa;
            max_summa_i = 0;
        }
        if (min_summa == -1) {
            min_summa = summa;
            min_summa_i = 0;
        }
        if (max_summa < summa) {
            max_summa = summa;
            max_summa_i = i;
        }
        if (min_summa > summa) {
            min_summa = summa;
            min_summa_i = i;
        }
        summa = 0;
    }
    
    // Добавляем в вектор(массив) b элементы из наибольшей и наименьшей строки чередованием
    int i = 0;
    for (int j=0; j < 3; j++){
        b[i] = a[max_summa_i][j];
        b[i+1] = a[min_summa_i][j];
        i += 2;
    }
    
    // Вывод вектора b
    printf("Вектор b:\n[%d, ", b[0]);
    for (int j=1; j< 5; j++) {
        printf("%d, ", b[j]);
    }
    printf("%d]", b[5]);

    return 0;
}