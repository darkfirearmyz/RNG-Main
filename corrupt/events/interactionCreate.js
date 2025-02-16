const resourcePath = global.GetResourcePath ? global.GetResourcePath(global.GetCurrentResourceName()) : global.__dirname
const { InteractionType, EmbedBuilder } = require("discord.js");
const fs = require("fs");

module.exports = async (client, interaction) => {
    if (!interaction.guild || interaction.user.bot || interaction.type !== InteractionType.ApplicationCommand) return;

    fs.readdir(resourcePath + "/commands", (err, files) => {
        if (err) throw err;

        files.forEach(async (f) => {
            let props = require(`../commands/${f}`);
            if (interaction.commandName.toLowerCase() === props.name.toLowerCase()) {
                if (interaction.guild.id === props.guild || !props.guild) {
                    const commandparams = interaction.options.data.map((x) => `${x.name}: ${x.value}`).join("\n") || `N/A`;
                    const botcmglog = new EmbedBuilder()
                    .setTitle("Bot Command Log")
                    .setDescription(`**Command Used**: ${interaction.commandName}\n**Command Parameters**: ${commandparams}\n**User**: ${interaction.user}\n**Server Link**: [Click Here](https://discord.com/channels/${interaction.guild.id})\n**Channel Link**: [Click Here](https://discord.com/channels/${interaction.guild.id}/${interaction.channel.id}/${interaction.id})`)
                    .setColor(0x0078ff)
                    .setTimestamp();
                    client.channels.cache.get("1271575959866183732").send({ embeds: [botcmglog] });
                    let userlevel = client.getPerms(interaction.member);
                    if (userlevel < props.perm) {
                        const embed = new EmbedBuilder()
                            .setTitle("Insufficient Permissions")
                            .setDescription("You do not have the required permissions to use this command.")
                            .setColor(0xFF0000)
                            .setTimestamp(new Date());
                        return interaction.reply({
                            embeds: [embed],
                            ephemeral: true
                        }).catch(e => console.error('Error sending reply:', e));
                    }
                } else {
                    if (props.support === true) {
                        let userlevel = client.getPerms(interaction.member);
                        if (userlevel > 9) {
                            const embed = new EmbedBuilder()
                                .setTitle("Insufficient Permissions")
                                .setDescription("You do not have the required permissions to use this command.")
                                .setColor(0xFF0000)
                                .setTimestamp(new Date());
                            return interaction.reply({
                                embeds: [embed],
                                ephemeral: true
                            }).catch(e => console.error('Error sending reply:', e));
                        }
                    } else {
                        interaction.reply({content : "This command is expected to be used within another guild.", ephemeral: true});
                        return;
                    }
                }
                try {
                    return props.run(client, interaction);
                } catch (e) {
                    const embed = new EmbedBuilder()
                        .setTitle("An Error Occurred")
                        .setDescription("An error occurred while running this command. Please contact a developer if this continues.")
                        .setColor(0x0099FF)
                        .setTimestamp(new Date());
                    return interaction.reply({
                        embeds: [embed],
                        ephemeral: true
                    }).catch(e => console.error('Error sending reply:', e));
                }
            }
        });
    });
};