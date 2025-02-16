const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "addcar",
    description: "Add Car To User ID",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "spawn_code",
            description: "Vehichle Spawn Code",
            type: 3,
            required: true,
        },
        {
            name: "lock",
            description: "Lock the vehicle",
            type: 5,
            required: true,
        }
    ],
    perm: 9,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);
        let permid = interaction.options.getInteger('user_id')
        let car = interaction.options.getString('spawn_code')
        let lock = interaction.options.getBoolean('lock')
        let newval = fivemexports.corrupt.corruptbot('AddCarNew', [permid, car, lock])
        const embed = new EmbedBuilder()
        .setTitle("Added Car")
        .setDescription("Perm ID: **" + permid + "**\nSpawn Code: **" + car + "**\n")
        .setColor(0x0078FF)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};