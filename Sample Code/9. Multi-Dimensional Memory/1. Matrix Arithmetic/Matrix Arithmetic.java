protected static double[][] multiply(	double[][]	m,
										double[][]	n) {
	int m1 = m.length;
	int m2 = m[0].length;
	int n1 = n.length;
	int n2 = n[0].length;
	if (m2 != n1)
		return null;
	double[][] o = new double[m1][n2];
	for (int i = 0; i < m1; i++)
		for (int j = 0; j < n2; j++) {
			o[i][j] = 0;
			for (int k = 0; k < m2; k++)
				o[i][j] += m[i][k] * n[k][j];
		}
	return o;
}

protected static double[][] multiply(	double		s,
										double[][]	m) {
	int m1 = m.length;
	int m2 = m[0].length;
	double[][] n = new double[m1][m2];
	for (int i = 0; i < m1; i++)
		for (int j = 0; j < m2; j++)
			n[i][j] = s * m[i][j];

	return n;
}

protected static double[][] add(		double[][]	m,
										double[][]	n) {
	int m1 = m.length;
	int m2 = m[0].length;
	int n1 = n.length;
	int n2 = n[0].length;
	if (m1 != n1 || m2 != n2)
		return null;

	double[][] o = new double[m1][m2];
	for (int i = 0; i < m1; i++)
		for (int j = 0; j < m2; j++)
			o[i][j] = m[i][j] + n[i][j];
	return o;
}

protected static double[][] subtract(	double[][]	m,
										double[][]	n) {
	int m1 = m.length;
	int m2 = m[0].length;
	int n1 = n.length;
	int n2 = n[0].length;
	if (m1 != n1 || m2 != n2)
		return null;

	double[][] o = new double[m1][m2];
	for (int i = 0; i < m1; i++)
		for (int j = 0; j < m2; j++)
			o[i][j] = m[i][j] - n[i][j];
	return o;
}