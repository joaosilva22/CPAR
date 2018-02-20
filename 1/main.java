class Main {
    public static int[][] createMatrix(int n) {
        return new int[n][n];
    }

    public static int[][] multMatrix(int[][] a, int[][] b, int n) {
        int c[][] = createMatrix(n);
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                for (int k = 0; k < n; ++k) {
                    c[i][j] += a[i][k] * b[k][j];
                }
            }
        }
        return c;
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Usage: java Main <n>");
            return;
        }

        int n = Integer.parseInt(args[0]);

        int a[][] = createMatrix(n);
        int b[][] = createMatrix(n);

        long start = System.nanoTime();
        multMatrix(a,b,n);
        
        System.out.println((System.nanoTime() - start) * 1.0e-9);
    }
}
