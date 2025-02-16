const { EmbedBuilder } = require('discord.js');

module.exports = {
    name: 'checkrented',
    description: 'Check rented vehicles for a user.',
    options: [
        {
            name: 'user_id',
            description: 'Perm ID',
            type: 4,
            required: true,
        },
    ],
    perm: 1,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const fivemexports = client.fivemexports;
        const permid = interaction.options.getInteger('user_id');
        const level = client.getPerms(interaction.member);
        let count = 0;
        fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_vehicles` WHERE rentedid = ?", [permid], async (result) => {
            if (result.length > 0) {
                const rentedvehicles = [];
                const results = result.length;

                for (let i = 0; i < results; i++) {
                    const renter = result[i].user_id;
                    const rentedtime = result[i].rentedtime;
                    const vehicle = result[i].vehicle;

                    const userResult = await fivemexports.corrupt.execute("SELECT * FROM `corrupt_users` WHERE id = ?", [renter]);
                    const username = userResult.length > 0 ? userResult[0].username : 'Unknown';

                    rentedvehicles.push(`${vehicle} rented to ${username}(${renter}) for ${Math.round((rentedtime - Math.floor(new Date().getTime() / 1000)) / 3600)} hours.\n`);
                    count++;

                    if (count === results) {
                        const embed = new EmbedBuilder()
                            .setTitle(`ID ${permid}'s Rented Vehicles :`)
                            .setDescription('\n```' + rentedvehicles.join('').replace(',', '') + '```')
                            .setColor(0x00ff00)
                            
                            .setTimestamp(new Date());

                        await interaction.reply({ embeds: [embed], ephemeral: true }).catch(async () => {
                            interaction.followUp(`ID ${permid} has too many rented vehicles to display in an embed.`);
                        });
                    }
                }
            } else {
                const embed = new EmbedBuilder()
                    .setTitle(`ID ${permid}'s Rented Vehicles :`)
                    .setDescription('No rented vehicles found.')
                    .setColor(0xff0000)
                    
                    .setTimestamp(new Date());
                await interaction.reply({ embeds: [embed], ephemeral: true });
            }
        });
    },
};
