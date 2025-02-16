const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "wlb",
    description: "Met Police Weekly Leaderboard",
    perm: 0,
    guild: "1293662946592952442",
    guild2: "put-nhs-guild-id-here",
    run: async (client, interaction) => {
        const fivemexports = interaction.client.fivemexports;
        const level = interaction.client.getPerms(interaction.member);
                                    // police guild id
        if (interaction.guild.id === "1293662946592952442") {
            fivemexports.corrupt.execute("SELECT * FROM corrupt_police_hours ORDER BY weekly_hours DESC", [], (result) => {
                var policeHoursLB = []
                if (result) {
                    for (i = 0; i < result.length; i++) {
                        if (i < 10) {
                            policeHoursLB.push(`\n${i+1}. ${result[i].username}(${result[i].user_id}) - ${result[i].weekly_hours.toFixed(2)} hours`)
                        }
                    }
                    const embed = new EmbedBuilder()
                        .setTitle(`Met Police Weekly Leaderboard`)
                        .setDescription('```' + policeHoursLB.join('') + '```')
                        .setColor(0x3498db)
                        .setTimestamp(new Date());
                    interaction.reply({ embeds: [embed], ephemeral: true });
                }
            })
                                            // nhs guild id
        } else if (interaction.guild.id === "1293664971586277437") {
            fivemexports.corrupt.execute("SELECT * FROM corrupt_nhs_hours ORDER BY weekly_hours DESC", [], (result) => {
                var nhsHoursLB = []
                if (result) {
                    for (i = 0; i < result.length; i++) {
                        if (i < 10) {
                            nhsHoursLB.push(`\n${i+1}. ${result[i].username}(${result[i].user_id}) - ${result[i].weekly_hours.toFixed(2)} hours`)
                        }
                    }
                    const embed = new EmbedBuilder()
                        .setTitle(`NHS Weekly Leaderboard`)
                        .setDescription('```' + nhsHoursLB.join('') + '```')
                        .setColor(0x3498db)
                        .setTimestamp(new Date());
                    interaction.reply({ embeds: [embed], ephemeral: true });
                }
            })
        }
    },
};
