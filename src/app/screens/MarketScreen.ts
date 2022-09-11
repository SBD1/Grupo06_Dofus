import chalk from "chalk";
import inquirer from "inquirer";
import dbInstance from "../connection/database.js";
import { Choices, INFINTE } from "../util/constants.js";
import { NPC } from "../interfaces/npc.js";
import { Item, TipoItem } from "../interfaces/item.js";
import PressToContinuePrompt, {
  KeyDescriptor,
} from "inquirer-press-to-continue";
inquirer.registerPrompt("press-to-continue", PressToContinuePrompt);

export default class MarketScreen {
  private readonly idPersonagem: number;
  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  public async handleMarketScreen(idNpc: number) {
    const merchant: NPC = (
      await dbInstance`SELECT * FROM npc WHERE id = ${idNpc}`
    )[0] as any;

    while (true) {
      console.clear();
      console.log();
      console.log();

      console.log(chalk.bgBlueBright(merchant.nome));
      console.log(merchant.descricao);

      const answer = await inquirer.prompt({
        name: "marketScreen",
        type: "list",
        loop: false,
        pageSize: INFINTE,
        message: "Selecione uma ação.\n",
        choices: [Choices.BUY, Choices.SELL, Choices.RETURN],
      });

      if (answer.marketScreen === Choices.RETURN) break;

      if (answer.marketScreen === Choices.BUY) await this.handleBuy(merchant);

      if (answer.marketScreen === Choices.SELL) await this.handleSell(merchant);
    }
  }

  private async handleSell(merchant: NPC) {
    console.clear();
    console.log();
    console.log();
    console.log("------ VENDA ------");
    console.log(chalk.bgBlueBright(merchant.nome));
    console.log(merchant.descricao);

    const items: Item[] = await dbInstance`
    SELECT I.id, I.nome, I.tipo_item, I.descricao, I.valor_moedas, count(I.id) as qnt, A.dano, B.vida, C.sorte FROM item I
        INNER JOIN instancia_item J ON I.id = J.id_item
        INNER JOIN mochila M ON M.id_instancia_item = J.id
        INNER JOIN personagens P ON p.id = M.id_personagem
        LEFT JOIN arma A ON A.id_item = I.id
        LEFT JOIN armadura B ON B.id_item = I.id
        LEFT JOIN amuleto C ON C.id_item = I.id
    WHERE P.id = ${this.idPersonagem}
    GROUP BY I.id, A.dano, B.vida, C.sorte
    `;

    const itemsObj: any = {};
    items.forEach((item) => {
      const key = `${item.nome} x${item.qnt} Valor unitário: ${item.valor_moedas}`;
      itemsObj[key] = item;
    });

    const answer = await inquirer.prompt({
      name: "handleSell",
      type: "list",
      loop: false,
      pageSize: INFINTE,
      message: "Selecione uma um item para ver informações.\n",
      choices: [...Object.keys(itemsObj), Choices.RETURN],
    });

    if (answer.handleSell === Choices.RETURN) return;

    await this.showItemToSellDetails(itemsObj[answer.handleSell]);
  }

  private async handleBuy(merchant: NPC) {
    console.clear();
    console.log();
    console.log();
    console.log("------ COMPRA ------");
    console.log(chalk.bgBlueBright(merchant.nome));
    console.log(merchant.descricao);

    const items: Item[] = await dbInstance`
    SELECT I.id, I.nome,I.descricao, I.valor_moedas, count(I.id) as qnt, A.dano, B.vida, C.sorte FROM item I
        INNER JOIN instancia_item J ON I.id = J.id_item
        INNER JOIN npc_mercador_itens M ON M.id_instancia_item = J.id
        INNER JOIN npc P ON p.id = M.id_npc_mercador
        LEFT JOIN arma A ON A.id_item = I.id
        LEFT JOIN armadura B ON B.id_item = I.id
        LEFT JOIN amuleto C ON C.id_item = I.id
        WHERE P.id = ${merchant.id}
    GROUP BY I.id, A.dano, B.vida, C.sorte
      `;

    const itemsObj: any = {};
    items.forEach((item) => {
      const key = `${item.nome} x${item.qnt} Valor unitário: ${item.valor_moedas}`;
      itemsObj[key] = item;
    });

    const answer = await inquirer.prompt({
      name: "handleBuy",
      type: "list",
      loop: false,
      pageSize: INFINTE,
      message: "Selecione uma um item para ver informações.\n",
      choices: [...Object.keys(itemsObj), Choices.RETURN],
    });

    if (answer.handleBuy === Choices.RETURN) return;

    await this.showItemToBuyDetails(itemsObj[answer.handleBuy], merchant);
  }

  private async showItemToBuyDetails(item: Item, merchant: NPC) {
    const itemAttributes: any = {};
    itemAttributes[TipoItem.AMULETO] = `Sorte:   ${item?.sorte}`;
    itemAttributes[TipoItem.ARMA] = `Dano   ${item?.dano}`;
    itemAttributes[TipoItem.ARMADURA] = `Vida   ${item?.vida}`;
    itemAttributes[TipoItem.NAO_EQUIPAVEL] = null;

    console.clear();
    console.log();
    console.log();

    console.log(chalk.cyanBright(item.nome));
    console.log(`Quantidade : ${item.qnt}`);
    console.log();
    console.log(item.descricao);
    console.log();
    console.log(itemAttributes[item.tipo_item]);
    console.log();

    const answer = await inquirer.prompt({
      name: "itemDetailsBuyScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [
        `${Choices.BUY} 1 unidade por ${item.valor_moedas} moedas`,
        Choices.RETURN,
      ],
    });

    if (answer.itemDetailsBuyScreen === Choices.RETURN) return;

    const hasEnoughMoney: { moedas: number } = (
      await dbInstance`SELECT moedas FROM personagens WHERE id = ${this.idPersonagem}`
    )[0] as any;

    if (!hasEnoughMoney?.moedas || hasEnoughMoney.moedas < item.valor_moedas) {
      console.clear();
      console.log();
      console.log();

      await inquirer.prompt<{ key: KeyDescriptor }>({
        name: "key",
        type: "press-to-continue",
        anyKey: true,
        pressToContinueMessage: `Você não tem moedas suficientes. Pressione qualquer tecla para continuar...`,
      } as any);

      return;
    }

    await dbInstance.unsafe(`
    START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
        _id_instancia_item INTEGER;
      BEGIN
        SELECT I.id INTO _id_instancia_item FROM instancia_item I
            LEFT JOIN npc_mercador_itens M ON M.id_instancia_item = I.id 
            WHERE I.id_item = ${item.id} AND M.id_npc_mercador = ${merchant.id}
            LIMIT 1;
        
        DELETE FROM npc_mercador_itens WHERE id_instancia_item = _id_instancia_item;

        INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, _id_instancia_item);
        UPDATE personagens SET moedas = moedas - ${item.valor_moedas};
      END;  
    $$;
    COMMIT;
    `);

    console.clear();
    console.log();
    console.log();

    await inquirer.prompt<{ key: KeyDescriptor }>({
      name: "key",
      type: "press-to-continue",
      anyKey: true,
      pressToContinueMessage: `Compra conclúida. Pressione qualquer tecla para continuar...`,
    } as any);
  }

  private async showItemToSellDetails(item: Item) {
    const itemAttributes: any = {};
    itemAttributes[TipoItem.AMULETO] = `Sorte:   ${item?.sorte}`;
    itemAttributes[TipoItem.ARMA] = `Dano   ${item?.dano}`;
    itemAttributes[TipoItem.ARMADURA] = `Vida   ${item?.vida}`;
    itemAttributes[TipoItem.NAO_EQUIPAVEL] = "";

    console.clear();
    console.log();
    console.log();

    console.log(chalk.cyanBright(item.nome));
    console.log(`Quantidade : ${item.qnt}`);
    console.log();
    console.log(item.descricao);
    console.log();
    console.log(itemAttributes[item.tipo_item]);
    console.log();

    const answer = await inquirer.prompt({
      name: "itemDetailsScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [
        `${Choices.SELL} 1 unidade por ${item.valor_moedas}`,
        Choices.RETURN,
      ],
    });

    if (answer.itemDetailsScreen === Choices.RETURN) return;

    await dbInstance.unsafe(`
    START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
        _id_instancia_item INTEGER;
      BEGIN
        SELECT I.id INTO _id_instancia_item FROM instancia_item I
            LEFT JOIN mochila M ON M.id_instancia_item = I.id 
            WHERE I.id_item = ${item.id} AND M.id_personagem = ${this.idPersonagem};
        
        DELETE FROM mochila WHERE id_instancia_item = _id_instancia_item AND id_personagem = ${this.idPersonagem};
        DELETE FROM instancia_item WHERE id = _id_instancia_item;
        UPDATE personagens SET moedas = moedas + ${item.valor_moedas};
      END;  
    $$;
    COMMIT;
    `);

    console.clear();
    console.log();
    console.log();

    await inquirer.prompt<{ key: KeyDescriptor }>({
      name: "key",
      type: "press-to-continue",
      anyKey: true,
      pressToContinueMessage: `Venda conclúida, você ganhou ${item.valor_moedas} moedas. Pressione qualquer tecla para continuar...`,
    } as any);
  }
}
