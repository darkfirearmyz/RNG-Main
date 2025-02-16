const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "guntoall",
    description: "Give A Gun To All Players",
    options: [
        {
            name: "gun",
            description: "Gun to give",
            type: 3,
            required: true,
            choices: [
                {
                     name: "Nerf Mosin",
                    value: "WEAPON_NERFMOSIN"
                },
                {
                    name: "Anonmous Sniper",
                    value: "WEAPON_ANONMOUSSNIPER"
                },
            ]
        }
    ],
    perm: 9,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);         
        let name = interaction.options.getString('gun')
        let newval = fivemexports.corrupt.corruptbot('GunToAll', [name])
        const embed = new EmbedBuilder()
        .setTitle("Gave Gun To All Players")
        .setDescription(`Gun: **${name}**\n\nAdmin: <@${interaction.user.id}>\n\n`)
        .setColor(0x0078ff)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};