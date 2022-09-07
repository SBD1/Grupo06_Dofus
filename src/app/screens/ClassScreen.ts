import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { Classe } from "../interfaces/classes.js";
import { Choices } from "../util/constants.js";

export default class ClassScreen {
  private readonly idPersonagem: number;

  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  private async pickClass() {
    console.clear();
    console.log();
    console.log("Você ainda não tem uma classe");

    let availableClasses: any = {};

    const classes: Classe[] = (await dbInstance`
        SELECT * FROM classe
        `) as any;

    classes.forEach((c) => {
      let key = c.nome;
      availableClasses[key] = c;
    });

    let didPickClass = false;
    while (!didPickClass) {
      const answer = await inquirer.prompt({
        name: "pickClass",
        type: "list",
        message: "Por favor, selecione uma classe para mais informações.\n",
        choices: [...Object.keys(availableClasses), Choices.QUIT],
      });

      if (answer.pickClass === Choices.QUIT) {
        process.exit(0);
      }

      didPickClass = await this.classDescription(
        availableClasses[answer.pickClass]
      );
    }
  }

  private async classDescription(classe: Classe): Promise<boolean> {
    console.clear();
    console.log();
    console.log();
    console.log(chalk.yellowBright(classe.nome));
    console.log();
    console.log(classe.descricao);
    console.log();
    console.log(
      chalk.greenBright(
        `Atributos básicos:     Vida incial: ${classe.vida_inicial}        Sorte inicial: ${classe.sorte}`
      )
    );
    console.log();
    console.log();

    const answer = await inquirer.prompt({
      name: "confirmClass",
      type: "list",
      message:
        "Deseja mesmo escolher essa classe? Essa ação não pode ser desfeita\n",
      choices: [Choices.YES, Choices.RETURN],
    });

    if (answer.confirmClass === Choices.YES) {
      await dbInstance`UPDATE personagens SET id_classe = ${classe.id}, vida_maxima = ${classe.vida_inicial} + vida_maxima, sorte_total = ${classe.sorte} + sorte_total WHERE id = ${this.idPersonagem}`;
      return true;
    }

    console.clear();

    return false;
  }

  public async handleClass() {
    console.clear();
    console.log();

    const hasClass = (
      await dbInstance`
        SELECT id_classe FROM personagens WHERE id = ${this.idPersonagem}
        `
    )[0].id_classe;

    if (!hasClass) {
      await this.pickClass();
    }
  }
}
