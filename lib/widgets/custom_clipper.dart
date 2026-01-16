import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 45.0; // Raio de 45px para os cantos superiores
    
    // Começa no canto inferior esquerdo - garante início na base
    path.moveTo(0, size.height);
    
    // Vai até o canto superior esquerdo
    path.lineTo(0, radius);
    
    // Canto superior esquerdo arredondado (45px)
    path.quadraticBezierTo(0, 0, radius, 0);
    
    // Linha reta no topo até próximo do canto superior direito
    path.lineTo(size.width - radius, 0);
    
    // Canto superior direito arredondado (45px)
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    
    // Garante que vai até o canto inferior direito (fechando completamente)
    path.lineTo(size.width, size.height);
    
    // Volta para o ponto inicial para fechar o caminho completamente
    path.lineTo(0, size.height);
    
    // Fecha o caminho explicitamente
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RoundedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 30.0;
    
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
