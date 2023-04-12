#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>
#include <float.h>

#define A 480

__thread unsigned int seed = 0;

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Specify the N\n");
        exit(EXIT_FAILURE);
    }

    struct timeval T1, T2;
    long delta_ms;
    int N = atoi(argv[1]); // N > 1 for the m2[N/2] to contain at least 1 number
    int M = N / 2;
    gettimeofday(&T1, NULL);

    int iter;
    for (iter = 0; iter < 100; ++iter) {
        int i;
        float m1[N];
        float m2[M];

        seed = iter;

        /* Generate */
        for (i = 0; i < N; ++i) {
            m1[i] = ((float) rand_r(&seed) / (float) RAND_MAX) * (A - 1) + 1;
        }

        for (i = 0; i < M; ++i) {
            m2[i] = ((float) rand_r(&seed) / (float) RAND_MAX) * (10*A - A) + A;
        }

        /* Map */
        for (i = 0; i < N; ++i) {
            m1[i] = 1 / tanhf(sqrtf(m1[i]));
        }

        float m2_copy[N/2];
        for (i = 0; i < M; ++i) {
            m2_copy[i] = m2[i];
        }
        for (i = 1; i < M; ++i) {
            float sum = m2_copy[i] + m2_copy[i-1];
            m2[i] = fabsf(tanf(sum));
        }

        /* Merge */
        for (i = 0; i < M; ++i) {
            m2[i] = (m1[i] < m2[i]) ? m1[i] : m2[i];
        }

        /* Sort */
        i = 0;
        while (i < M - 1) {
            if (m2[i] > m2[i + 1]) {
                float t = m2[i];
                m2[i] = m2[i + 1];
                m2[i + 1] = t;
                i = 0;
            }
            else {
                i++;
            }
        }

        /* Reduce */
        float min = FLT_MAX;
        for (i = 0; i < M; ++i) {
            if (m2[i] != 0 && m2[i] < min) {
                min = m2[i];
                break;
            }
        }

        float sum = 0;
        for (i = 0; i < M; ++i) {
            if ((int)(m2[i] / min) % 2 == 0) {
                sum += sinf(m2[i]);
            }
        }
       // printf("%f\n", sum);
    }

    gettimeofday(&T2, NULL);
    delta_ms = 1000 * (T2.tv_sec - T1.tv_sec) + (T2.tv_usec - T1.tv_usec) / 1000;
    printf("\nN=%d. Milliseconds passed: %ld\n", N, delta_ms); /* T2 - T1 */
    return 0;
}

