import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _loading = false;

  Future<void> _acceptTerms() async {
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'termos_aceitos': true,
          'data_aceite': FieldValue.serverTimestamp(),
          'versao_termos': '2.0.2025',
          'email': user.email,
        }, SetOptions(merge: true));

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint("Erro ao salvar aceite: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na validação: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    const Color(0xFFFF8C00).withOpacity(0.1),
                    Colors.black
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildTermsContent()),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          const Icon(Icons.shield_outlined, color: Color(0xFFFF8C00), size: 45),
          const SizedBox(height: 10),
          const Text(
            "COMPROMISSO TRANSMITA.AI",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          Text(
            "Ecossistema Protegido e Independente",
            style:
                TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(Icons.history_edu, "ORIGEM E AUTORIDADE (EST. 2021)",
                "Este ecossistema é fruto da visão estratégica do Founder Lucas Ferreira, concebido desde 2021 após vasta experiência no setor audiovisual de alto nível e estudos. A Transmita.ai não é apenas um serviço ou produtora, mas uma infraestrutura de engenharia proprietária construída do zero."),
            _section(Icons.verified, "MARCA REGISTRADA E PROTEÇÃO INPI",
                "A marca 'Transmita.ai' é devidamente registrada junto ao INPI. Todo o conjunto de códigos, metodologias híbridas (IA + Atores Reais) e arquitetura Flutter/Serverless são ativos intelectuais protegidos por lei."),
            _section(Icons.gavel_rounded, "INDEPENDÊNCIA DE ENGENHARIA",
                "O usuário reconhece que este software foi desenvolvido de forma independente, utilizando tecnologias de mercado (Flutter, Firebase) e lógica proprietária, sendo juridicamente desvinculado de quaisquer ativos de empresas terceiras ou ex-vínculos do fundador."),
            _section(Icons.privacy_tip_outlined, "PRIVACIDADE E LGPD",
                "Em total conformidade com a Lei Geral de Proteção de Dados (Lei 13.709/2018), garantimos o controle total sobre seus dados. Você detém o direito ao acesso, correção e exclusão ('Direito ao Esquecimento') de suas informações a qualquer momento."),
            _section(Icons.settings_remote_outlined, "METODOLOGIA HÍBRIDA",
                "Nossa entrega utiliza uma fusão entre inteligência computacional e talentos humanos. O aceite destes termos valida a compreensão de que a Transmita.ai opera como uma infraestrutura tecnológica B2B."),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "© 2025 Transmita.ai | Todos os direitos reservados.",
                style: TextStyle(color: Colors.white24, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFF8C00), size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C00),
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: _loading ? null : _acceptTerms,
          child: _loading
              ? const CircularProgressIndicator(color: Colors.black)
              : const Text("CONCORDO COM OS TERMOS",
                  style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
