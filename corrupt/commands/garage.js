const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "garage",
    description: "Gets the garage of a player",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        }
    ],
    perm: 1,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        const fivemexports = interaction.client.fivemexports;
        const user_id = interaction.options.getInteger('user_id');
        let count = 0;
        let vehicles = [];

        fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_vehicles` WHERE user_id = ?", [user_id], (result) => {
            if (result.length === 0) {
                return interaction.reply({ content: `ID ${user_id} has no vehicles in their garage.`, ephemeral: true });
            }

            result.forEach((vehicle) => {
                const vehicleString = vehicle.rented ? `${vehicle.vehicle} - Rented` : vehicle.vehicle;
                vehicles.push(vehicleString);
                count++;

                if (count === result.length) {
                    const embed = new EmbedBuilder()
                        .setTitle(`ID ${user_id}'s Garage:`)
                        .setDescription(`\`\`\`\n${vehicles.join('\n')}\`\`\``)
                        .setColor(0x0078ff)
                        .setTimestamp(new Date());

                    interaction.reply({ embeds: [embed], ephemeral: true }).catch(err => {
                        console.error(err);
                    });
                }
            });
        });
    },
};
