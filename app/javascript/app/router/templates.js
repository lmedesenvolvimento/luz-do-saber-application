import Acentuacao from "../components/templates/Acentuacao.vue";
import AgrupamentoImagem from "../components/templates/AgrupamentoImagem.vue";
import AgrupamentoMaiusculas from "../components/templates/AgrupamentoMaiusculas.vue";
import AlternativaImagemSelecao from "../components/templates/AlternativaImagemSelecao.vue";
import ApresentacaoImagem from "../components/templates/ApresentacaoImagem.vue";
import TextoAlternativa from "../components/templates/TextoAlternativa.vue";
import Alternativa from "../components/templates/Alternativa.vue";
import AlternativaAudioX from "../components/templates/AlternativaAudioX.vue";
import AlternativaImagemX from "../components/templates/AlternativaImagemX.vue";
import AlternativaImagemSubtitulo from "../components/templates/AlterntivaImagemSubtitulo.vue"
import AlternativaTextoSubtitulo from "../components/templates/AlternativaTextoSubtitulo.vue"
import ApresentacaoLeitura from "../components/templates/ApresentacaoLeitura.vue";
import ApresentacaoVideo from "../components/templates/ApresentacaoVideo.vue";
import BingoPalavras from "../components/templates/BingoPalavras.vue";
import CacaPalavras from "../components/templates/CacaPalavras.vue";
import CaixaPalavras from "../components/templates/CaixaPalavras.vue";
import CharadaLetras from "../components/templates/CharadaLetras.vue";
import CompleteFrase from "../components/templates/CompleteFrase.vue";
import ConsoanteNome from "../components/templates/ConsoanteNome.vue";
import DescubraLetraEncaixar from "../components/templates/DescubraLetraEncaixar.vue";
import DescubraPalavra from "../components/templates/DescubraPalavra.vue";
import DesembaralheNome from "../components/templates/DesembaralheNome.vue";
import DitadoFrase from "../components/templates/DitadoFrase.vue";
import DitadoLetras from "../components/templates/DitadoLetras.vue";
import DitadoPalavras from "../components/templates/DitadoPalavras.vue";
import EscrevaPalavra from "../components/templates/EscrevaPalavra.vue";
import JogoMemoriaPalavraImagem from "../components/templates/JogoMemoriaPalavraImagem.vue";
import MarquePalavras from "../components/templates/MarquePalavras.vue";
import LetrasMaiuscula from "../components/templates/LetrasMaiuscula.vue";
import PalavrasComImagem from "../components/templates/PalavrasComImagem.vue";
import PalavrasComImagemValues from "../components/templates/PalavrasComImagensValues.vue";
import LigacaoTextoTexto from "../components/templates/LigacaoTextoTexto.vue";
import MeuCracha from "../components/templates/MeuCracha.vue";
import MeuNome from "../components/templates/MeuNome.vue";
import MonteFraseArrastar from "../components/templates/MonteFraseArrastar.vue";
import Ortografia from "../components/templates/Ortografia.vue";
import PalavraSimples from "../components/templates/PalavraSimples.vue";
import QualSilaba from "../components/templates/QualSilaba.vue";
import QuantidadeLetras from "../components/templates/QuantidadeLetras.vue";
import QuestionarioItemImagem from "../components/templates/QuestionarioItemImagem.vue";
import SegmentacaoFrases from "../components/templates/SegmentacaoFrases.vue";
import SelecioneNome from "../components/templates/SelecioneNome.vue";
import SinaisPontuacao from "../components/templates/SinaisPontuacao.vue";
import SomSilaba from "../components/templates/SomSilaba.vue";
import TiposLetrasConjunto from "../components/templates/TiposLetrasConjunto.vue";
import UsoPorques from "../components/templates/UsoPoques.vue";
import Rima from "../components/templates/Rima.vue";
import NotFound from "../components/templates/NotFound.vue";
import VogalNome from "../components/templates/VogalNome.vue";
import SequenciaNumerica from "../components/templates/SequenciaNumerica.vue";
import SequenciaNumericaAntecessor from "../components/templates/SequenciaNumericaAntecessor.vue";

export default [
  {
    path: "acentuacao",
    component: Acentuacao,
  },
  {
    path: "agrupamento-de-imagem",
    component: AgrupamentoImagem,
  },
  {
    path: "agrupamento-de-maiusculas",
    component: AgrupamentoMaiusculas,
  },
  {
    path: "alternativa",
    component: Alternativa,
  },
  {
    path: "alternativa-audio-x",
    component: AlternativaAudioX,
  },
  {
    path: "alternativa-imagem-selecao",
    component: AlternativaImagemSelecao,
  },
  {
    path: "alternativa-imagem-x",
    component: AlternativaImagemX,
  },
  {
    path: "alternativa-imagens-com-subtitulo",
    component: AlternativaImagemSubtitulo,
  },
  {
    path: "alternativa-texto-com-subtitulo",
    component: AlternativaTextoSubtitulo,
  },
  {
    path: "apresentacao-imagem",
    component: ApresentacaoImagem,
  },
  {
    path: "apresentacao-leitura",
    component: ApresentacaoLeitura,
  },
  {
    path: "apresentacao-video",
    component: ApresentacaoVideo,
  },
  {
    path: "bingo-de-palavras",
    component: BingoPalavras,
  },
  {
    path: "caca-palavras",
    component: CacaPalavras,
  },
  {
    path: "caixa-de-palavras",
    component: CaixaPalavras,
  },
  {
    path: "charada-de-letras",
    component: CharadaLetras,
  },
  {
    path: "complete-a-frase-escrever",
    component: CompleteFrase,
  },
  {
    path: "complete-a-palavra-com-letra",
    component: PalavrasComImagem,
  },
  {
    path: "complete-seu-nome",
    component: DesembaralheNome,
  },
  {
    path: "consoantes-do-meu-nome",
    component: ConsoanteNome,
  },
  {
    path: "decomposicao-da-palavra-geradora",
    component: EscrevaPalavra,
  },
  {
    path: "descubra-a-letra-faltante-encaixar",
    component: DescubraLetraEncaixar,
  },
  {
    path: "descubra-a-letra-faltante-selecao",
    component: DescubraLetraEncaixar,
  },
  {
    path: "descubra-a-palavra",
    component: DescubraPalavra,
  },
  {
    path: "desembaralhe-seu-nome",
    component: DesembaralheNome,
  },
  {
    path: "ditado-de-frases-escrever",
    component: DitadoFrase,
  },
  {
    path: "ditado-de-letras",
    component: DitadoLetras,
  },
  {
    path: "ditado-de-palavras",
    component: DitadoPalavras,
  },
  {
    path: "domino-de-nomes",
    component: DitadoPalavras
  },
  {
    path: "encaixe-de-letra",
    component: CacaPalavras,
  },
  {
    path: "escreva-a-palavra",
    component: EscrevaPalavra,
  },
  {
    path: "escreva-seu-nome",
    component: MeuNome,
  },
  {
    path: "formacao-de-palavras",
    component: PalavrasComImagem,
  },
  {
    path: "jogo-da-memoria-palavra-imagem",
    component: JogoMemoriaPalavraImagem,
  },
  {
    path: "jogo-da-memoria-imagem-imagem",
    component: JogoMemoriaPalavraImagem,
  },
  {
    path: "jogo-da-memoria-palavra-palavra",
    component: PalavrasComImagemValues,
  },
  {
    path: "letras-maiusculas",
    component: LetrasMaiuscula,
  },
  {
    path: "ligacao-texto-imagem",
    component: PalavrasComImagem,
  },
  {
    path: "ligacao-texto-texto",
    component: LigacaoTextoTexto,
  },
  {
    path: "ligacao-letra-inicial",
    component: LigacaoTextoTexto,
  },
  {
    path: "marque-as-palavras",
    component: MarquePalavras,
  },
  {
    path: "meu-cracha",
    component: MeuNome,
  },
  {
    path: "monte-a-frase-arrastar",
    component: MonteFraseArrastar,
  },
  {
    path: "monte-a-palavra-com-silabas",
    component: PalavrasComImagem,
  },
  {
    path: "monte-seu-nome",
    component: DesembaralheNome,
  },
  {
    path: "ortografia",
    component: Ortografia,
  },
  {
    path: "palavra-secreta",
    component: PalavrasComImagem,
  },
  {
    path: "qual-a-silaba",
    component: QualSilaba,
  },
  {
    path: "quantidade-de-letras",
    component: QuantidadeLetras,
  },
  {
    path: "quantidade-de-silabas",
    component: QuantidadeLetras,
  },
  {
    path: "quebra-cabecas",
    component: MeuNome,
  },
  {
    path: "questionario-item-imagem",
    component: QuestionarioItemImagem,
  },
  {
    path: "rimas",
    component: Rima,
  },
  {
    path: "risca-letras",
    component: DesembaralheNome,
  },
  {
    path: "segmentacao-de-frases",
    component: SegmentacaoFrases,
  },
  {
    path: "segredo-das-palavras",
    component: CacaPalavras,
  },
  {
    path: "selecione-seu-nome",
    component: SelecioneNome,
  },
  {
    path: "separacao-silabica",
    component: PalavrasComImagem,
  },
  {
    path: "sinais-de-pontuacao",
    component: SinaisPontuacao,
  },
  {
    path: "som-das-palavras",
    component: AlternativaImagemSelecao,
  },
  {
    path: "som-das-silabas",
    component: SomSilaba,
  },
  {
    path: "texto-alternativa",
    component: TextoAlternativa,
  },
  {
    path: "tipos-de-letras-conjuntos",
    component: TiposLetrasConjunto,
  },
  {
    path: "ultima-do-meu-nome",
    component: DesembaralheNome,
  },
  {
    path: "uso-dos-porques",
    component: UsoPorques,
  },
  {
    path: "vogais-do-meu-nome",
    component: VogalNome,
  },
  {
    path: "sequencia-numerica",
    component: SequenciaNumerica,
  },
  {
    path: "sequencia-numerica-2",
    component: SequenciaNumericaAntecessor,
  },
  {
    path: "*",
    component: NotFound,
  },
];
