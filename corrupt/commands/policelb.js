const { EmbedBuilder } = require('discord.js');

module.exports = {
    name: "lb",
    description: "Met Police Leaderboard",
    perm: 0,
    guild: "1293662946592952442",
    run: async (client, interaction) => {
        const fivemexports = interaction.client.fivemexports;
        const level = interaction.client.getPerms(interaction.member);
        fivemexports.corrupt.execute("SELECT * FROM corrupt_police_hours ORDER BY total_hours DESC", [], (result) => {
            var policeHoursLB = []
            if (result) {
                for (i = 0; i < result.length; i++) {
                    if (i < 10) {
                        policeHoursLB.push(`\n${i+1}. ${result[i].username}(${result[i].user_id}) - ${result[i].total_hours.toFixed(2)} hours`)
                    }
                }
                const embed = new EmbedBuilder()
                    .setTitle(`Met Police Leaderboard`)
                    .setDescription('```' + policeHoursLB.join('') + '```')
                    .setColor(0x3498db)
                    .setTimestamp(new Date());
                interaction.reply({ embeds: [embed], ephemeral: true });
            }
        })
    },
};
