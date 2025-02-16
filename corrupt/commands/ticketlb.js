const { EmbedBuilder } = require('discord.js');

module.exports = {
    name: "ticketlb",
    description: "Staff Ticket Leaderboard Of The Week",
    perm: 1,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const fivemexports = interaction.client.fivemexports;
        const level = interaction.client.getPerms(interaction.member);
        fivemexports.corrupt.execute("SELECT * FROM corrupt_staff_tickets ORDER BY ticket_count DESC", [], (result) => {
            var staffticketlb = []
            if (result) {
                for (i = 0; i < result.length; i++) {
                    if (i < 10) {
                        staffticketlb.push(`\n${i+1}. ${result[i].username}(${result[i].user_id}) - ${result[i].ticket_count} Tickets`)
                    }
                }
                const embed = new EmbedBuilder()
                    .setTitle(`Corrupt Staff Ticket Leaderboard`)
                    .setDescription('```' + staffticketlb.join('') + '```')
                    .setColor(0x0078ff)
                    .setTimestamp(new Date());
                interaction.reply({ embeds: [embed], ephemeral: true });
            }
        })
    },
};
