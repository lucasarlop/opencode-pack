# AGENTS.md

<!-- INSTRUÇÕES PARA /init:
  - Preencha APENAS as seções marcadas com [PREENCHER]
  - NÃO modifique seções marcadas com [FIXO] — são parte do protocolo do projeto
  - NÃO altere caminhos como .opencode/, são convenções do projeto
-->

> **ATENÇÃO:** Este projeto utiliza **exclusivamente** o diretório `.opencode/` para
> regras, specs, templates, commands e skills. NÃO procure nem crie arquivos em
> `.claude/`, `.cursor/`, `.copilot/`, `.github/copilot-instructions.md` ou qualquer
> outro diretório específico de ferramenta. Toda a configuração do agente está em
> `.opencode/` e no presente arquivo.

---

Propósito
Este arquivo guia ferramentas de codificação agêntica trabalhando neste repositório.
Foca no protocolo de planejamento Spec-First, comandos de build/teste e
convenções de código do projeto.

## 1. Protocolo Operacional: Spec-First (Obrigatório) [FIXO]

**CRÍTICO:** Você deve seguir o protocolo **Spec-First** para cada modificação, a fim de garantir previsibilidade e estabilidade.
Regras detalhadas estão em `.opencode/rules/planning.md`.

1. **Modo PLAN (Fase de Planejamento)**:
   - **Analisar**: Leia a solicitação e mapeie as dependências no código-fonte existente.
   - **Rascunho da Spec**: Crie um novo arquivo de especificação em `.opencode/specs/NNNN_<nome_da_tarefa>.json`.
   - **Template**: Utilize estritamente o modelo localizado em `.opencode/templates/spec_template.json`.
   - **Restrição**: **NÃO** modifique nenhum código-fonte enquanto estiver nesta fase. Sua saída deve ser apenas o plano.
   - ⚠️ Apresentar o plano apenas em texto **sem criar o arquivo JSON é uma violação do protocolo**.
2. **Revisão**: Apresente o plano ao usuário para confirmação. Aguarde aprovação explícita antes de avançar.
3. **Modo BUILD (Fase de Execução)**:
   - **Executar**: Somente após aprovação, execute os passos do plano utilizando o comando `/execute` ou chamadas manuais de ferramentas.
   - **Verificar**: Garanta que cada passo atenda a seus critérios de verificação.
   - **Encerrar**: Atualize o status da especificação para "completed" ao concluir.

---

## 2. Visão Geral do Projeto [PREENCHER]

<!-- /init: descreva stack, entry point, módulos principais e propósito do projeto -->

---

## 3. Build e Execução [PREENCHER]

<!-- /init: preencha com os comandos reais do projeto -->
- Build:
- Executar aplicação:
- Limpar:
- Build sem testes:
- Listar tasks:

---

## 4. Testes [PREENCHER]

<!-- /init: preencha com os comandos e padrões de teste do projeto -->
- Task de teste padrão:
- Classe de teste individual:
- Método de teste individual:
- Pacote ou padrão:

### Quando adicionar testes
- Use o framework de testes padrão do projeto.
- Coloque os testes no diretório de testes com pacote correspondente.
- Mantenha nomes de teste descritivos e nomes de método explícitos.
- Prefira testes determinísticos; evite temporização baseada em sleep quando possível.

### TDD — quando aplicar [FIXO]

Consulte a skill `tdd` para o protocolo completo.

- **Aplicar**: lógica de negócio isolada, funções puras, parsers, validações, ETL transforms.
- **Não aplicar**: endpoints de API sem lógica complexa, UI, scripts de automação simples.
- A spec deve declarar `"tdd_required": true/false` explicitamente.

---

## 5. Lint / Formatação [PREENCHER]

<!-- /init: preencha com linter/formatter do projeto, ou indique que não há nenhum configurado -->
- Não introduza uma ferramenta nova a menos que solicitado.
- Mantenha a formatação consistente com os arquivos existentes.
- Evite mudanças grandes que sejam apenas reformatação.

---

## 6. Dependências e Sistema de Build [PREENCHER]

<!-- /init: preencha com gerenciador de pacotes, repositório de dependências, toolchain -->
- Mantenha versões fixadas a menos que solicitado a atualizar.
- Prefira conjuntos de dependências pequenos; evite adicionar bibliotecas pesadas.
- Não introduza dependências sem aprovação explícita.

---

## 7. Ambiente e Infraestrutura [FIXO + PREENCHER]

### Python [FIXO]
- Virtualenv: sempre usar `.venv` local ao projeto.
- Formatação: ruff — rodar antes de commitar.
- Testes: pytest — obrigatório para lógica de negócio isolada.

### Docker [FIXO]
- Sempre verificar se existe `docker-compose.yml` antes de rodar serviços.
- Preferir `docker compose up -d` para subir dependências locais.
- Nunca hardcodar portas ou credenciais — usar `.env` (nunca commitado).
- Verificar saúde dos containers com `docker compose ps` após subir.

### Versões e Comandos [PREENCHER]

<!-- /init: preencha versão de runtime, gerenciador de pacotes e comandos reais do projeto -->

---

## 8. Layout dos Fontes [PREENCHER]

<!-- /init: liste os diretórios principais como lista simples (caminho: descrição).
     Formato esperado (NÃO gere árvore de diretórios):
     - src/main/java: código-fonte principal
     - src/test/java: testes
     - .opencode/specs: especificações de tarefas
-->

---

## 9. Diretrizes de Estilo de Código [PREENCHER]

<!-- /init: preencha com os padrões específicos do projeto -->

### Geral
- Siga o estilo minimalista existente: classes simples, poucas abstrações.
- Prefira nomes claros em vez de esperteza.
- Mantenha arquivos pequenos e focados em uma responsabilidade.
- Evite fluxo de controle profundamente aninhado; extraia helpers quando necessário.

### Imports
<!-- /init: preencha a ordem de imports do projeto -->
- Evite imports com wildcard/curinga.
- Remova imports não utilizados.

### Formatação
<!-- /init: preencha regras de indentação, tamanho de linha, etc. -->

### Tipos e Naming
<!-- /init: preencha convenções de tipos e nomenclatura do projeto -->

### Tratamento de Erros e Logging
- Prefira logging estruturado em vez de System.out/err (ou equivalente) se logging for introduzido.
- Ao adicionar tratamento de erros, inclua contexto (IDs relevantes, sessão, etc.).
- Evite engolir exceções silenciosamente; faça log ou propague.
- Use exceções verificadas (checked) apenas quando for possível recuperar de forma significativa.
- Ao capturar exceções amplas, adicione um comentário explicando o porquê.

### Concorrência
- Seja explícito quanto à propriedade e ciclo de vida das threads.
- Use coleções thread-safe para dados compartilhados.
- Se adicionar novas threads, nomeie-as e documente seu propósito.
- Evite estado mutável compartilhado a menos que necessário.

### Gerenciamento de Recursos
- Use try-with-resources (ou equivalente) para recursos que precisam ser fechados.
- Garanta que threads em background possam ser encerradas se você adicionar novas.
- Libere recursos nativos prontamente quando aplicável.

---

## 10. O que NÃO Fazer [FIXO]

- Não modificar arquivos fora do escopo da spec aprovada.
- Não introduzir dependências sem aprovação explícita.
- Não hardcodar credenciais, URLs de produção ou secrets.
- Não reformatar arquivos sem necessidade.
- Não commitar `.env`, `.venv`, `__pycache__`, `node_modules/` ou arquivos de build.
- Não alterar `docker-compose.yml` sem mencionar explicitamente no plano.
- Não editar arquivos não relacionados.
- Manter commits focados em uma preocupação.

---

## 11. Configuração e Secrets [FIXO]

- Não commitar secrets ou credenciais reais.
- Usar placeholders em código de exemplo ou documentação.
- Usar variáveis de ambiente ou arquivos de configuração para credenciais reais.

---

## 12. Arquivos de Referência [FIXO]

- Protocolo de planejamento: `.opencode/rules/planning.md`
- Template de spec: `.opencode/templates/spec_template.json`
- Specs anteriores: `.opencode/specs/`
- ADRs: `.opencode/docs/adr/`
- Diagramas C4 + sequência (Mermaid): skill `diagrams`

---

## 13. Quando Estiver em Dúvida [FIXO]

- Siga os padrões atuais no código-fonte do projeto.
- Prefira mudanças pequenas e incrementais.
