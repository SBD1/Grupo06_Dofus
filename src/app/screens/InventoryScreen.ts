import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { Choices } from "../util/constants.js";
import { Item, TipoItem } from "../interfaces/item.js";

export default class InventoryScreen {
  private readonly idPersonagem;

  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  async handleInventoryScreen(): Promise<void> {
    console.clear();
    console.log();
    console.log();

    const answer = await inquirer.prompt({
      name: "inventoryScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [
        Choices.LIST_ITEMS,
        Choices.LIST_WEAPONS,
        Choices.LIST_ARMOR,
        Choices.LIST_AMULETS,
        Choices.RETURN,
      ],
    });

    if (answer.inventoryScreen === Choices.RETURN) return;

    const items: Item[] = await dbInstance`
      SELECT I.id, I.nome, I.tipo_item, I.descricao, I.valor_moedas, A.dano, B.vida, C.sorte, count(I.id) as qnt FROM item I
      INNER JOIN instancia_item J ON I.id = J.id_item
      INNER JOIN mochila M ON M.id_instancia_item = J.id
      INNER JOIN personagens P ON p.id = M.id_personagem
      LEFT JOIN arma A ON A.id_item = I.id
      LEFT JOIN armadura B ON B.id_item = i.id
      LEFT JOIN amuleto C ON C.id_item = I.id
      WHERE P.id = ${this.idPersonagem}
      GROUP BY I.id, A.dano, B.vida, C.sorte
    `;

    await this.listItems(answer.inventoryScreen, items);
  }

  private async listItems(choice: string, items: Item[]) {
    console.clear();
    console.log();
    console.log();

    const mapItemType: any = {};
    mapItemType[Choices.LIST_AMULETS] = TipoItem.AMULETO;
    mapItemType[Choices.LIST_WEAPONS] = TipoItem.ARMA;
    mapItemType[Choices.LIST_ARMOR] = TipoItem.ARMADURA;
    mapItemType[Choices.LIST_ITEMS] = TipoItem.NAO_EQUIPAVEL;

    console.log("Selecione o item para ver mais informações");

    const filteredItems: any = {};

    items.forEach((item) => {
      if (item.tipo_item === mapItemType[choice]) {
        const key = `${item.nome}  Quantidade: ${item.qnt}`;

        filteredItems[key] = item;
      }
    });

    const answer = await inquirer.prompt({
      name: "listItemsScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [...Object.keys(filteredItems), Choices.RETURN],
    });

    if (answer.listItemsScreen === Choices.RETURN) return;

    await this.showItemDetails(filteredItems[answer.listItemsScreen]);
  }

  private async showItemDetails(item: Item) {
    const itemAttributes: any = {};
    itemAttributes[TipoItem.AMULETO] = `Sorte:   ${item.sorte}`;
    itemAttributes[TipoItem.ARMA] = `Dano   ${item.dano}`;
    itemAttributes[TipoItem.ARMADURA] = `Vida   ${item.vida}`;
    itemAttributes[TipoItem.NAO_EQUIPAVEL] = null;

    console.clear();
    console.log();
    console.log();

    console.log(chalk.cyanBright(item.nome));
    console.log(`Quantidade : ${item.qnt}`);
    console.log();
    console.log();
    console.log(item.descricao);
    console.log();
    console.log(itemAttributes[item.tipo_item]);

    const equip: string[] = [];
    if (item.tipo_item !== TipoItem.NAO_EQUIPAVEL) equip.push(Choices.EQUIP);

    const answer = await inquirer.prompt({
      name: "itemDetailsScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [...equip, Choices.RETURN],
    });
  }
}
