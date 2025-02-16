const { EmbedBuilder } = require('discord.js');
const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(`${resourcePath}/settings.js`);

module.exports = {
    name: "groups",
    description: "See all the groups of a player",
    options: [
        {
            name: "user_id",
            description: "Perm ID",
            type: 4,
            required: true,
        }
    ],
    perm: 5,
    guild: "1271575952115368008",
    support: true,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        let level = client.getPerms(interaction.member);        
        let user_id = interaction.options.getInteger('user_id')

        fivemexports.corrupt.execute("SELECT * FROM `corrupt_user_data` WHERE user_id = ?", [user_id], (result) => {
            if (result.length > 0) {
                obj = JSON.parse(result[0].dvalue).groups

                if (Object.entries(obj).length > 0) {
                    const embed = new EmbedBuilder()
                        .setTitle(`**User Groups** ${user_id}`)
                        .setDescription(`**Success**! Groups have been fetched for User ID: ***${user_id}***`)
                        .setColor(settingsjson.settings.botColour)
                        .addFields(
                            { name: 'Perm ID:', value: `${user_id}` },
                            { name: 'Groups:', value: `${(JSON.stringify(Object.keys(obj)).replace(/"/g, '').replace('[', '').replace(']', '')).replace(/,/g, ', ')}` }
                        )
                        .setTimestamp(new Date());

                    return interaction.reply({ embeds: [embed], ephemeral: true });
                } else {
                    const embed = new EmbedBuilder()
                        .setTitle('No Groups')
                        .setDescription('No groups for this user.')
                        .setColor(0xff0000)
                        .setTimestamp(new Date());

                    return interaction.reply({ embeds: [embed], ephemeral: true });
                }
            } else {
                const embed = new EmbedBuilder()
                    .setTitle('No Groups')
                    .setDescription('No groups for this user.')
                    .setColor(0xff0000)
                    .setTimestamp(new Date());

                return interaction.reply({ embeds: [embed], ephemeral: true });
            }
        });
    },
};
