const { EmbedBuilder } = require('discord.js');
const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname;
const settingsjson = require(`${resourcePath}/settings.js`);

const groups = ['Supporter', 'Premium', 'Supreme', 'Kingpin', 'Rainmaker', 'Baller'];
const hoursRoles = ['1000', '2000', '3000', '4000', '5000'];

module.exports = {
    name: 'getroles',
    description: 'Automatically grants roles based on donation status and playtime.',
    perm: 0,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        const fivemexports = client.fivemexports;
        const author_id = interaction.user.id;
        let rolesCount = 0;
        let rolesOwned = [];
        let descriptionText = ':white_check_mark: You have received your discord roles:';
        let rolesToAdd = [];
        fivemexports.corrupt.execute(
            "SELECT user_id FROM `corrupt_verification` WHERE discord_id = ?",
            [author_id],
            (result) => {
            let user_id = result[0].user_id;
            fivemexports.corrupt.execute(
                "SELECT * FROM `corrupt_user_data` WHERE user_id = ? AND dkey = 'CORRUPT:datatable'",
                [user_id],
                async (data) => {
                if (data.length > 0 && data[0].dvalue) {
                    const userData = JSON.parse(data[0].dvalue);
                    let userGroups = Object.keys(userData.groups || {});
                    let userHours = Math.round(userData.PlayerTime / 60);
                    const memberRoles = interaction.member.roles;
                    for (const key of hoursRoles) {
                        if (userHours > key) {
                            let role = interaction.guild.roles.cache.find(r => r.name === `${key}`);
                            if (role && !memberRoles.cache.has(role.id)) {
                                rolesCount += 1;
                                rolesOwned.push(`\n${key}`);
                                rolesToAdd.push(role);
                            }
                        }
                    }              
                    for (const key of userGroups) {
                    if (groups.includes(key)) {
                        let role = interaction.guild.roles.cache.find(r => r.name === `${key}`);
                        if (role && !memberRoles.cache.has(role.id)) {
                        rolesCount += 1;
                        rolesOwned.push(`\n${key}`);
                        rolesToAdd.push(role);
                        }
                    }
                    }

                    if (rolesCount > 0) {
                        const embed = new EmbedBuilder()
                        .setTitle('Roles')
                        .setDescription(descriptionText + '```\n' + rolesOwned.join('').replace(',', '') + '```')
                        .setColor(settingsjson.settings.botColour)
                        .setTimestamp(new Date());
                        interaction.reply({ embeds: [embed], ephemeral: true });
                    for (const roleToAdd of rolesToAdd) {
                        await interaction.member.roles.add(roleToAdd).catch(console.error);
                    }
                    } else {
                        const noRolesEmbed = new EmbedBuilder()
                        .setTitle('No Roles Found')
                        .setDescription("You have no missing roles that need adding.")
                        .setColor(settingsjson.settings.botColour)
                        .setTimestamp(new Date());
                        interaction.reply({ embeds: [noRolesEmbed], ephemeral: true });
                    }
                } else {
                    console.log("Data not found or dvalue missing.");
                }
            });
        });
    },
};
