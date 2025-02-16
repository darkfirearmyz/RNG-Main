const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "punishments",
    description: "See all punishments for the server",
    perm: 7,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        
        fivemexports.corrupt.execute("SELECT * FROM corrupt_users WHERE banned = 1", (bannedPlayers) => {
            fivemexports.corrupt.execute("SELECT * FROM corrupt_anticheat", (totalACBans) => {
                const embed = new EmbedBuilder()
                .setTitle("Punishment Statistics")
                .setDescription(`Currently Banned:\n - Total Banned: **${bannedPlayers.length}**\n\n - Anticheat Banned: **${totalACBans.length}** \n\n - Staff Banned: **${bannedPlayers.length-totalACBans.length}**\n\n`)
                .setColor(0x0078FF)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            });
        });
    },
};