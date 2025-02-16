const { EmbedBuilder } = require('discord.js');
const { SlashCommandBuilder } = require('discord.js');

module.exports = {
    name: "help",
    description: "Help Command",
    options: [
        {
            name: "command",
            description: "Command Name",
            type: 3,
            required: false
        }
    ],
    perm: 0,
    run: async (client, interaction) => {
        let fivemexports = client.fivemexports;
        const command = interaction.options.getString('command');
        if (interaction.guild.id == "1271575952115368008") {
            if (command) {
                const cmd = client.commands.find(cmd => cmd.name === command);
                if (cmd) {
                    const embed = new EmbedBuilder()
                        .setTitle(`Command: ${cmd.name}`)
                        .setDescription(`Description: ${cmd.description}`)
                        .setColor(0x0078ff)
                        .setTimestamp(new Date());

                    interaction.reply({ embeds: [embed], ephemeral: true });
                } else {
                    interaction.reply({ content: "Command not found.", ephemeral: true });
                }
            } else {
                const embed = new EmbedBuilder()
                    .setTitle("Corrupt Droid Help")
                    .setDescription("__**Useful Links**__\n[Support Discord](https://discord.gg/A8Ern2Y38K)\n[Store](https://corrupt.tebex.io)\n\n__**Commands**__\n/bid\n/getroles\n/ch\n/verify")
                    .setColor(0x0078ff)
                    .setThumbnail("https://cdn.discordapp.com/attachments/1129927706621005864/1198686465710903416/blue.png")
                    .setFooter({ text: 'To find specific information about commands use /help [command]'});

                interaction.reply({ embeds: [embed], ephemeral: true });
            }
        } else if (interaction.guild.id == "1182793770194972842") {
            const embed = new EmbedBuilder()
                .setTitle("Corrupt Police Help")
                .setDescription("__**Commands**__\n/info\n/lb\n/wlb")
                .setColor(0x3498db)
                .setFooter({ text: 'To find specific information about commands use /help [command]'});

            interaction.reply({ embeds: [embed], ephemeral: true });
        }
    },
};
