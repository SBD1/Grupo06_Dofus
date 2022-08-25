import chalk from 'chalk';
import inquirer from 'inquirer';
import gradient from 'gradient-string';
import chalkAnimation from 'chalk-animation';
import figlet from 'figlet';

export default class Game {
    constructor() {
        this.run()
    }

    private async run () {
        figlet('DOFUS', 'Doom', (_err, data) => {
            console.log(gradient.pastel.multiline(data) + '\n');
          });
    }
}