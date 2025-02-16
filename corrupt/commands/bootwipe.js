const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "bootwipe",
    description: "Wipe the server",
    perm: 10,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        // only let do command at end of month
        let date = new Date();
        let first = new Date(date.getFullYear(), date.getMonth(), 1);
        let lastDayOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);
        if (date.getDate() !== first.getDate()) {
            const embed = new EmbedBuilder()
                .setTitle("Failed to Wipe Server")
                .setDescription("You can only wipe the server on the first day of the month")
                .setColor(0xFF0000);
            interaction.reply({ embeds: [embed], ephemeral: true });
            return;
        }
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);         
        let newval = fivemexports.corrupt.corruptbot('EndBootWipe', []);
        const embed = new EmbedBuilder()
            .setTitle("Wiping Server")
            .setDescription(`Admin: <@${interaction.user.id}>\n\n`)
            .setColor(0x0078ff)
            .setTimestamp(new Date());
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};
