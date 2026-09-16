# Portfolio

Portfólio profissional de uma única pessoa, com área pública de leitura e um
painel de administração para editar todo o conteúdo. Um único cliente (app
Flutter): no web serve as duas áreas; no celular só o painel.

## Language

### Identidade

**Admin**:
A única pessoa dona do portfólio; a única identidade que pode se autenticar.
Não existe outro tipo de conta nem registro público.
_Avoid_: User, usuário, dono, owner

**Visitor**:
Qualquer pessoa usando o app sem autenticação. Só lê conteúdo e envia
mensagens de contato.
_Avoid_: user, guest, público (como substantivo), role "user"

**Profile**:
Os dados de apresentação do Admin exibidos na seção "Sobre" (descrição,
localização, disponibilidade, idiomas, foto). É conteúdo público; nunca inclui
credenciais.
_Avoid_: Sobre, About, User, dados do usuário

### Conteúdo

**Project**:
Um trabalho exibido na vitrine do portfólio, com descrição, tecnologias, links
e uma galeria de imagens. Identificado publicamente pelo seu slug.
_Avoid_: case, portfolio item, trabalho

**ProjectImage**:
Uma imagem da galeria de um Project, com posição própria na galeria. Pertence a
exatamente um Project.
_Avoid_: foto, upload, attachment, galeria (como entidade)

**SkillCategory**:
Um agrupamento nomeado de Skills (ex.: "Linguagens", "Bancos de dados").
_Avoid_: grupo, área, stack

**Skill**:
Uma competência técnica nomeada, pertencente a exatamente uma SkillCategory.
_Avoid_: tecnologia, ferramenta, tag

**Experience**:
Um período de trabalho em uma empresa, com cargo e atividades. Sem data de fim
significa "atual".
_Avoid_: job, emprego, cargo (como entidade), work history

**Education**:
Um curso ou formação em uma instituição, com ano de início e fim.
_Avoid_: formação, degree, curso (como entidade)

**Offering**:
Um serviço que o Admin oferece a clientes (ex.: "Desenvolvimento de APIs").
Exibido ao Visitor sob o rótulo "Serviços".
_Avoid_: Service (colide com a camada de serviço do código), serviço (em código)

**ContactLink**:
Um canal público pelo qual o Visitor pode alcançar o Admin (e-mail, LinkedIn,
GitHub…), com rótulo, texto exibido e destino abrível.
_Avoid_: social, rede social, contato (como entidade), link (genérico)

**ContactMessage**:
Uma mensagem enviada por um Visitor ao Admin pelo formulário de contato. Fica
guardada até o Admin apagá-la; pode estar lida ou não lida.
_Avoid_: mensagem de e-mail, ticket, inbox (como entidade)

**CV**:
O currículo em PDF, montado sob demanda a partir de Profile, ContactLinks,
Experiences, Educations, Skills e Offerings. Não é um arquivo armazenado.
_Avoid_: resume (em código), currículo estático, upload de CV

### Ordenação

**Position**:
A posição editorial de um item dentro da sua coleção, definida pelo Admin.
Determina a ordem de exibição de tudo que não é cronológico.
_Avoid_: order, sort, index, rank
