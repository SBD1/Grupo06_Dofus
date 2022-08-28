export enum TipoNPC {
    MONSTRO = 'monstro',
    NPC_MISSAO = 'npc_missao',
    MERCADOR = 'mercador'
}

export interface NPC {
    id: number
    nome: string
    tipo_npc: TipoNPC
    descricao: string
    id_mapa: number
}