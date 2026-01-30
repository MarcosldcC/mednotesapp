/// Dados de um passo da simulação (Telas 2 a 6).
class OnCallSimulationStepData {
  final String cardTitle;
  final String cardContent;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String feedbackCorrect;
  final String feedbackError;

  const OnCallSimulationStepData({
    required this.cardTitle,
    required this.cardContent,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.feedbackCorrect,
    required this.feedbackError,
  });
}

/// Conteúdo das telas 2 a 6 da simulação Modo Plantão.
class OnCallSimulationSteps {
  static const List<OnCallSimulationStepData> steps = [
    // Tela 2 - RCP em andamento
    OnCallSimulationStepData(
      cardTitle: 'RCP em andamento',
      cardContent: 'Compressões: 100–120/min\nProfundidade: 5–6 cm\nRecoil completo\nMínimas interrupções',
      question: 'Qual conduta deve ser associada agora?',
      options: [
        'Solicitar monitorização contínua e acesso venoso',
        'Pausar RCP para intubação',
        'Administrar choque',
        'Solicitar exames laboratoriais',
      ],
      correctIndex: 0,
      feedbackCorrect: 'Iniciar monitorização e acesso sem interromper a RCP.',
      feedbackError: 'Interromper a RCP neste momento reduz a chance de sobrevida.',
    ),
    // Tela 3 - Avaliação do Ritmo
    OnCallSimulationStepData(
      cardTitle: 'Avaliação do Ritmo',
      cardContent: 'Monitor: Assistolia\nFC: 0 bpm\nRitmo não chocável',
      question: 'Qual a próxima conduta?',
      options: [
        'Administrar adrenalina 1 mg IV/IO',
        'Desfibrilar',
        'Administrar amiodarona',
        'Administrar atropina',
      ],
      correctIndex: 0,
      feedbackCorrect: 'Assistolia não é ritmo chocável. Adrenalina é indicada.',
      feedbackError: 'Choque não é indicado em assistolia.',
    ),
    // Tela 4 - Via Aérea
    OnCallSimulationStepData(
      cardTitle: 'Abordagem de Via Aérea',
      cardContent: 'RCP em andamento\nOxigenação necessária',
      question: 'Qual a melhor conduta neste momento?',
      options: [
        'Ventilação com bolsa-válvula-máscara + O₂ 100%',
        'Intubação imediata com pausa da RCP',
        'Ventilação excessiva',
        'Suspender compressões',
      ],
      correctIndex: 0,
      feedbackCorrect: 'Via aérea não deve interromper a RCP.',
      feedbackError: 'Interromper compressões piora o prognóstico.',
    ),
    // Tela 5 - Reavaliação
    OnCallSimulationStepData(
      cardTitle: 'Reavaliação do Ritmo',
      cardContent: 'Persistência de assistolia\nSem pulso palpável',
      question: 'Qual a conduta correta agora?',
      options: [
        'Retomar RCP imediatamente e preparar nova dose de adrenalina',
        'Desfibrilar',
        'Encerrar protocolo',
        'Aguardar resposta da medicação',
      ],
      correctIndex: 0,
      feedbackCorrect: 'A RCP deve ser retomada imediatamente após checagem rápida.',
      feedbackError: 'A demora reduz drasticamente a chance de retorno da circulação.',
    ),
    // Tela 6 - Causas Reversíveis
    OnCallSimulationStepData(
      cardTitle: 'Investigação de Causas Reversíveis',
      cardContent: 'Hipóxia\nHipovolemia\nAcidose\nDistúrbios eletrolíticos\nTromboembolismo\nTamponamento cardíaco\nPneumotórax hipertensivo',
      question: 'Qual ação é essencial neste momento?',
      options: [
        'Investigar e tratar causas reversíveis mantendo RCP',
        'Aguardar retorno espontâneo',
        'Encerrar atendimento',
        'Solicitar exames antes',
      ],
      correctIndex: 0,
      feedbackCorrect: 'Sem tratar a causa, a PCR não se reverte.',
      feedbackError: 'Interromper a abordagem ativa compromete o desfecho.',
    ),
  ];

  static OnCallSimulationStepData stepAt(int index) => steps[index];
}
