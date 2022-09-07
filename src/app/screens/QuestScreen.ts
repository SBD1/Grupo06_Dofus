import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";

export class QuestScreen {
  private readonly idPersonagem: number;

  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  public async handleQuestScreen() {}
}
