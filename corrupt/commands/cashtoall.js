const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "cashtoall",
    description: "Give Money To All Players",
    options: [
        {
            name: "amount",
            description: "How much money to give",
            type: 4,
            required: true,
        },
    ],
    perm: 10,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);         
        let amount = interaction.options.getInteger('amount')
        let newval = fivemexports.corrupt.corruptbot('CashToAll', [amount])
        const embed = new EmbedBuilder()
        .setTitle("Gave Money To All Players")
        .setDescription(`Amount: **${amount}**\n\nAdmin: <@${interaction.user.id}>\n\n`)
        .setColor(0x0078ff)
        .setTimestamp(new Date())
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};