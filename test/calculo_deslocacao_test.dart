import 'package:flutter_test/flutter_test.dart';

// Exemplo de função (substitui pelo que já tens na tua app)
double calcularDeslocacao(double kms, double valorKm) {
  return kms * valorKm;
}

void main() {
  test('Cálculo de deslocação deve estar correto', () {
    expect(calcularDeslocacao(10, 0.5), 5.0);
    expect(calcularDeslocacao(0, 0.5), 0.0);
    expect(calcularDeslocacao(20, 1.0), 20.0);
  });
}
