const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "removegroup",
    description: "Removes A Group From A User",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        },
        {
            name: "group",
            description: "Group Name",
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
        let permid = interaction.options.getInteger('user_id')
        let group = interaction.options.getString('group')
        fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_data` WHERE user_id = ?", [permid], (result) => {
            if (result.length > 0) {
                let dvalue = JSON.parse(result[0].dvalue)
                let groups = dvalue.groups
                groups[group] = undefined;
                fivemexports.corrupt.execute("UPDATE `corrupt_user_data` SET dvalue = ? WHERE user_id = ?", [JSON.stringify(dvalue), 1])
            }
        })

        const embed = new EmbedBuilder()
        .setTitle("Removed Group From User")
        .setDescription(`\nPerm ID: **${permid}**\n\nGroup Name: **${group}**\n\nAdmin: <@${interaction.user.id}>`)
        .setColor(0x0078FF)
        interaction.reply({ embeds: [embed], ephemeral: true });
    },
};