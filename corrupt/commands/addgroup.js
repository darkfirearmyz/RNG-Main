const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "addgroup",
    description: "Add Group To User ID",
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
    perm: 7,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);
            
        let permid = interaction.options.getInteger('user_id')
        let group = interaction.options.getString('group')
        fivemexports.corrupt.corruptbot("getUserSource", [permid], (result) => {
            if (result !== null) {
                fivemexports.corrupt.corruptbot("addUserGroup", [permid, group], (result) => {})
            } else {
                fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_data` WHERE user_id = ? AND dkey = ?", [permid, "CORRUPT:datatable"], (result) => {
                    if (result.length > 0) {
                        let dvalue = JSON.parse(result[0].dvalue)
                        let groups = dvalue.groups
                        groups[group] = true;
                        fivemexports.corrupt.execute("UPDATE `corrupt_user_data` SET dvalue = ? WHERE user_id = ?", [JSON.stringify(dvalue), permid])
                    }
                })
            }
        })

        const embed = new EmbedBuilder()
        .setTitle("Added Group To User")
        .setDescription(`\nPerm ID: **${permid}**\nGroup Name: **${group}**\n\nAdmin: <@${interaction.user.id}>`)
        .setColor(0x0078FF)
        interaction.reply({ embeds: [embed], ephemeral: true });

    },
};