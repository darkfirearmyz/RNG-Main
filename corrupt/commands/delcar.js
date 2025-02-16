const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "delcar",
    description: "Delete A Car From A User",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "spawncode",
            description: "Cars Spawncode",
            type: 3,
            required: true,
        }

    ],
    perm: 6,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);     
        let user_id = interaction.options.getInteger('user_id')   
        let spawncode = interaction.options.getString('spawncode')
        fivemexports.corrupt.execute("DELETE FROM corrupt_user_vehicles WHERE user_id = ? AND vehicle = ?", [user_id, spawncode], (result) => {
            if (result) {
                const embed = new EmbedBuilder()
                .setTitle("Delete Car")
                .setDescription(`\nSuccess! Removed Car ID: **${user_id}**\n\n SpawnCode: **${spawncode}**`)
                .setColor(0x0078ff)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            } else {
                const embed = new EmbedBuilder()
                .setTitle("Delete Car")
                .setDescription(`\nFailed! This car for UserID: **${user_id}**\n\n SpawnCode: **${spawncode}** already is gone!`)
                .setColor(0xFF0000)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            }
        })
    },
};