import '../models/product.dart';

/// Lista única de produtos mock para Marketplace e CategoryProducts.
/// Evita duplicação e centraliza alterações futuras.
final List<Product> mockProducts = [
  Product(
    id: '1',
    title: 'ECG na Prática Cliníca',
    description: 'Interpretação do ECG na prática em 30 dias.',
    price: 120.00,
    rating: 4.7,
    acquiredCount: 1250,
    category: 'Cursos',
  ),
  Product(
    id: '2',
    title: 'Anatomia Clínica Completa',
    description: 'Guia completo de anatomia para médicos.',
    price: 89.90,
    rating: 4.8,
    acquiredCount: 890,
    category: 'Livros',
  ),
  Product(
    id: '3',
    title: 'Estetoscópio Premium',
    description: 'Estetoscópio de alta qualidade para diagnóstico.',
    price: 250.00,
    rating: 4.9,
    acquiredCount: 450,
    category: 'Itens',
  ),
  Product(
    id: '4',
    title: 'Farmacologia Avançada',
    description: 'Livro completo sobre farmacologia clínica.',
    price: 95.00,
    rating: 4.6,
    acquiredCount: 650,
    category: 'Livros',
  ),
  Product(
    id: '5',
    title: 'Curso de Emergências',
    description: 'Curso completo sobre atendimento de emergências.',
    price: 150.00,
    rating: 4.9,
    acquiredCount: 1200,
    category: 'Cursos',
  ),
];
