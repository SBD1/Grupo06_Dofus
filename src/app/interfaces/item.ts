export enum TipoItem {
  ARMA = "arma",
  AMULETO = "amuleto",
  ARMADURA = "armadura",
  NAO_EQUIPAVEL = "nao_equipavel",
}

export interface Item {
  id: number;
  nome: string;
  tipo_item: TipoItem;
  descricao: string;
  valor_moedas: number;
  qnt: number;
  sorte?: number;
  vida?: number;
  dano?: number;
}
