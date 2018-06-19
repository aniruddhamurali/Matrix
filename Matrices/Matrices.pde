/* *************************************************
 * * PROJECT: MATRIX SOLVER                        *
 * *************************************************
 *
 * @author Aniruddha Murali
 */
 
 
 
/** Matrices.pde
 * Uses the Processing programming language (based off Java)
 * User can utilize the Matrix abstraction to perform a multitude of operations, such as: 
 *   - addition, 
 *   - multiplication, 
 *   - determinant, 
 *   - inverse, 
 *   - removing a row and column, 
 *   - minors, 
 *   - cofactors, 
 *   - transpose, 
 *   - and rotating rows.
 *
 */


/** void setup()
 * Testing the methods of the Matrix class
 */
void setup() {
  
  // Setting up three sample matrices for testing
  float[][] matrix1 = {{2, 6}, 
                       {7, 3}}; 
  float[][] matrix2 = {{1, 5}, 
                       {0, 5}};
  float[][] matrix3 = {{2, 4, 1}, 
                       {-1, 1, -1},
                       {1, 4, 0}}; 
   
  // Calling the methods of the Matrix class for testing
  float[][] sumMatrix     = Matrix.addMatrices(matrix1,matrix2);
  float[][] productMatrix = Matrix.multiply(matrix1,matrix2);
  float[][] minors        = Matrix.minors(matrix3);
  float[][] rrac          = Matrix.removeRowAndColumn(matrix3, 1, 2);
  float[][] cofactors     = Matrix.cofactors(minors);
  float[][] transpose     = Matrix.transpose(matrix3);
  float[][] intMult       = Matrix.multiply(matrix2, 2);
  float[][] inverse       = Matrix.inverse(matrix3);
  
  // Printing the resulting matrix
  println("Inverse of matrix3:");
  Matrix.printM(inverse);
  
  /*
  Matrix.printM(sumMatrix);
  Matrix.printM(productMatrix);
  Matrix.printM(minors);
  Matrix.printM(rrac);
  Matrix.printM(cofactors);
  Matrix.printM(transpose);
  Matrix.printM(intMult);
  */
}



/** Matrix class
 * class for performing matrix operations
 * static - class does not require instantiation to utilize methods
 *
 */
public static class Matrix {
  
  /** void printM()
   * This method prints the matrix on the lower screen
   *
   * @param matrix (float[][]) - matrix to be printed
   * @return none
   */
  public static void printM(float[][] matrix) {
    for (int i = 0; i < matrix.length; i++) {
      print("[");
      for (int j = 0; j < matrix[0].length; j++) {
        if (j == matrix[0].length - 1) print(matrix[i][j]);
        else print(matrix[i][j] + ", ");
      }
      print("]");
      println();
    }
  }
  
  
  /** float[][] construct()
   * This method creates an empty matrix (2 dimensional array) with the 
   * specified rows and columns
   *
   * @param rows (int) - number of rows
   * @param columns (int) - number of columns
   * @return matrix(float[][]) - empty rows by columns matrix
   */
  public static float[][] construct(int rows, int columns) {
    float[][] matrix = new float[rows][columns];
    return matrix;
  }
  
  
  /** float[][] add()
   * This method adds adds matrices together and returns the result
   *
   * @param matrix1 (float[][]) - the first matrix
   * @param matrix2 (float[][]) - the second matrix
   * @return answer(float[][]) - the resulting matrix after addition
   */
  public static float[][] addMatrices(float[][] matrix1, float[][] matrix2) {
    float[][] answer = construct(matrix1.length, matrix1[0].length);
    for (int i = 0; i < matrix1.length; i++) {
      for (int j = 0; j < matrix1[0].length; j++) {
        answer[i][j] = matrix1[i][j] + matrix2[i][j];
      }
    }
    return answer;
  }
  
  
  /** float[][] multiply()
   * This method multiplies matrices together and returns the result
   *
   * @param matrix1 (float[][]) - the first matrix
   * @param matrix2 (float[][]) - the second matrix
   * @return answer(float[][]) - the resulting matrix after multiplication
   */
  public static float[][] multiply(float[][] matrix1, float[][]matrix2) {
    float[][] answer = construct(matrix1.length, matrix2[0].length);
    for (int i = 0; i < matrix1.length; i++) { // row of matrix 1
      for (int j = 0; j < matrix2[0].length; j++) { // column of matrix 2
        int sum = 0;
        for (int k = 0; k < matrix1[0].length; k++) {
           sum += matrix1[i][k] * matrix2[k][j];
        }
        answer[i][j] = sum;
      }
    }
    return answer;
  }
  
  
  /** float[][] multiply()
   * This method multiplies a matrix and a scalar value together 
   * and returns the result
   *
   * @param matrix1 (float[][]) - the first matrix
   * @param n (float) - a scalar value (one number)
   * @return answer(float[][]) - the resulting matrix after multiplication
   */
  public static float[][] multiply(float[][] matrix, float n) {
    float[][] answer = construct(matrix.length, matrix[0].length);
    for (int i = 0; i < matrix.length; i++) { // rows
      for (int j = 0; j < matrix[0].length; j++) { // columns
        answer[i][j] = matrix[i][j] * n;
      }
    }
    return answer;
  }
  
  
  /** float[][] determinant()
   * This method calculates and returns the determinant of a matrix
   *
   * @param matrix (float[][]) - the input matrix
   * @return determinant(float[][]) - the determinant matrix
   */
  public static float determinant(float[][] matrix) {
    float determinant = 0;
    if (matrix.length == 1) return matrix[0][0];
    else if (matrix.length == 2) {
      return matrix[0][0]*matrix[1][1] - matrix[0][1]*matrix[1][0];
    }
    
    float[][] temp = construct(matrix.length-1, matrix.length-1);
    for (int i = 0; i < matrix.length; i++) { // columns
      int x = 0; // variable representing the column being selected
      for (int j = 0; j < matrix.length; j++) { // rows
        if (j != i) { // i column is not included for determinant
          for (int k = 1; k < matrix.length; k++) {
            temp[k-1][x] = matrix[k][j];
          }
          x += 1;
        }
      }
      determinant += pow(-1,i) * matrix[0][i] * determinant(temp);
    }
    return determinant;
  }
  
  
  /** float[][] removeRowAndColumn()
   * This method constructs a new matrix with the row and column specified deleted
   *
   * @param inputMatrix (float[][]) - the input matrix
   * @param row (int) - row to be removed
   * @param column (int) - column to be removed
   * @return outputMatrix(float[][]) - the resulting matrix
   */
  public static float[][] removeRowAndColumn(float[][] inputMatrix, int row, int column) {
    float[][] outputMatrix = construct(inputMatrix.length-1, inputMatrix[0].length-1);
    int x = 0; int y = 0;
    
    for (int i = 0; i < inputMatrix.length; i++) {
      for (int j = 0; j < inputMatrix[i].length; j++) {
        if (i == row || j == column) continue;
        else if (y >= outputMatrix.length) break;
        else {
          outputMatrix[x][y] = inputMatrix[i][j];
          y++;
        }
      }
      if (i != row) x++;
      y = 0;
    }
    return outputMatrix;
  }
  
  
  /** float[][] minors()
   * This method returns the minors matrix
   *
   * @param matrix (float[][]) - the input matrix
   * @return answer(float[][]) - the resulting matrix
   */
  public static float[][] minors(float[][] matrix) {
    float[][] answer = construct(matrix.length, matrix[0].length);
    for (int i = 0; i < matrix[0].length; i++) { // columns
      for (int j = 0; j < matrix.length; j++) { // rows
        answer[j][i] = determinant(removeRowAndColumn(matrix, j, i));
       } 
    }      
    return answer;
  }
  
  
  /** float[][] cofactors()
   * This method returns the cofactors matrix
   *
   * @param matrix (float[][]) - the input matrix
   * @return answer(float[][]) - the resulting matrix
   */
  public static float[][] cofactors(float[][] matrix) {
    float[][] answer = construct(matrix.length, matrix[0].length);
    for (int i = 0; i < matrix[0].length; i++) { // columns
      for (int j = 0; j < matrix.length; j++) { // rows
        if ((i+j) % 2 == 1) answer[j][i] = -1*matrix[j][i];
        else answer[j][i] = matrix[j][i];
      }
    }
    return answer;
  }
  
  
  /** float[][] transpose()
   * This method returns the transpose of a matrix
   *
   * @param matrix (float[][]) - the input matrix
   * @return answer(float[][]) - the resulting matrix
   */
  public static float[][] transpose(float[][] matrix) {
    float[][] answer = construct(matrix.length, matrix[0].length);
    float[] row;
    for (int i = 0; i < matrix[0].length; i++) { // columns
      row = matrix[i];
      for (int j = 0; j < row.length; j++) {
        answer[j][i] = row[j];
      }
    }
    return answer;
  }
  
  
  /** float[][] inverse()
   * This method returns the inverse of a matrix
   *
   * @param matrix (float[][]) - the input matrix
   * @return float[][] - uses the tranpose, cofactors, minors, and determinant matrices 
   * to calculate the inverse of a matrix
   */
  public static float[][] inverse(float[][] matrix) {
    float[][] answer = transpose(cofactors(minors(matrix)));
    if (determinant(matrix) == 0) {
      println("This matrix does not have an inverse.");
      return null;
    }
    else return multiply(answer, 1/(determinant(matrix)));
  }
  
  
  /** float[][] rotateRows()
   * This method swaps the rows in a matrix. 
   * row 1 goes to row 0, row 2 goes to row 1, row 0 goes to row 2
   *
   * @param matrix (float[][]) - the input matrix
   * @return float[][] - uses the tranpose, cofactors, minors, and determinant matrices 
   * to calculate the inverse of a matrix
   */
  public static float[][] rotateRows(float[][] matrix) {
    float[][] answer = construct(matrix.length, matrix[0].length);
    for (int i = 1; i < matrix.length; i++) {
      answer[i-1] = matrix[i];
    }
    answer[answer.length-1] = matrix[0];
    return answer;
  }
}