const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "movecar",
    description: "Move Car To Another User",
    options: [
        {
            name: "user_id",
            description: "Current Owner Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "new_user_id",
            description: "New Owner Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "spawn_code",
            description: "Vehichle Spawn Code",
            type: 3,
            required: true,
        }
    ],
    perm: 10,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);
        let permid = interaction.options.getInteger('user_id')
        let car = interaction.options.getString('spawn_code')
        let newpermid = interaction.options.getInteger('new_user_id')
        fivemexports.corrupt.execute("UPDATE corrupt_user_vehicles SET user_id = ? WHERE user_id = ? AND vehicle = ?", [newpermid, permid, car], (result) => {
            if (result) {
                const embed = new EmbedBuilder()
                .setTitle("Moved Car")
                .setDescription("Perm ID: **" + permid + "**\nSpawn Code: **" + car + "**\nNew Perm ID: **" + newpermid + "**")
                .setColor(0x0078FF)
                .setTimestamp(new Date())
                interaction.reply({ embeds: [embed], ephemeral: true });
            } else {
                const embed = new EmbedBuilder()
                .setTitle("Failed to Move Car")
                .setDescription("Perm ID **" + permid + "** does not own **" + car + "**")
                .setColor(0xFF0000)
                interaction.reply({ embeds: [embed], ephemeral: true });
            }
        })
    },
};