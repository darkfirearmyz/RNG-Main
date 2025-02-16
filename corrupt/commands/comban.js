const { ActionRowBuilder, ButtonBuilder, ButtonStyle, PermissionsBitField, EmbedBuilder } = require('discord.js');

module.exports = {
    name: 'comban',
    description: 'Ban a player from the server and all Discord servers.',
    options: [
        {
            name: 'user_id',
            type: 4,
            description: 'Perm ID',
            required: true,
        }
    ],
    perm: 9,
    guild: "1271575952115368008",
    run: async (client, interaction) => {
        if (!interaction) return;

        const fivemexports = client.fivemexports;
        const permid = interaction.options.getInteger('user_id');
        const adminname = interaction.user.username;
        const reason = "Community Ban";
        const serversbanned = [];
        const unableToBan = [];

        fivemexports.corrupt.execute("SELECT * FROM `corrupt_verification` WHERE user_id = ?", [permid], async (result) => {
            if (result.length > 0) {
                const discord_id = result[0].discord_id;
                const member = interaction.guild.members.cache.get(discord_id);
                const perms = member.permissions.has(PermissionsBitField.Flags.BanMembers);
                if (perms) {
                    const ErrorEmbed = new EmbedBuilder()
                        .setTitle('Corrupt Community Ban')
                        .setDescription(`Unable to ban <@${discord_id}> because they have the ban permissions.`)
                        .setColor('#ff0000')
                        .setTimestamp();
                    interaction.reply({ embeds: [ErrorEmbed], ephemeral: true });
                    return;
                }
                const row = new ActionRowBuilder()
                    .addComponents(
                        new ButtonBuilder()
                            .setCustomId('confirm_ban')
                            .setLabel('Confirm')
                            .setStyle(ButtonStyle.Danger),
                        new ButtonBuilder()
                            .setCustomId('cancel_ban')
                            .setLabel('Cancel')
                            .setStyle(ButtonStyle.Primary)
                    );

                const SuccessEmbed = new EmbedBuilder()
                    .setTitle('Corrupt Community Ban')
                    .setDescription(`Do you really want to ban <@${discord_id}>?`)
                    .setColor(0x0078ff)
                    .setFooter({text: `Waiting on you to confirm.`})
                    .setTimestamp();

                const message = await interaction.reply({ embeds: [SuccessEmbed], ephemeral: true, components: [row] });

                const filter = i => i.customId === 'confirm_ban' || i.customId === 'cancel_ban';

                const collector = interaction.channel.createMessageComponentCollector({ filter, time: 15000 });

                collector.on('collect', async i => {
                    if (i.customId === 'confirm_ban') {
                        for (const [guildId, guild] of client.guilds.cache) {
                            try {
                                await guild.members.ban(discord_id, { reason: reason });
                                serversbanned.push(`:white_check_mark: ${guild.name}`);
                            } catch (error) {
                                serversbanned.push(`:x: ${guild.name}`);
                            }
                        }
                        // Ban from external system
                        let newval = fivemexports.corrupt.corruptbot('banDiscord', [permid, "perm", `Community Ban`, `${adminname} via Discord.`, `No Evidence Needed`]);
                        // Respond to the interaction
                        const SuccessEmbed = new EmbedBuilder()
                            .setTitle('Corrupt Community Ban')
                            .setDescription(`Successfully banned <@${discord_id}> from the server and all Discord servers.\n\n**${serversbanned.join('\n')}**`)
                            .setColor(0x0078ff)
                            .setFooter({text: `Trying To Send DM`})
                            .setTimestamp();
                        interaction.reply({ embeds: [SuccessEmbed], ephemeral: true });

                        // Send DM to the banned user
                        const dmEmbed = new EmbedBuilder()
                            .setTitle('Corrupt Community Ban')
                            .setDescription(`You have been banned from the server and all Discord servers.\n\n${serversbanned.join('\n')}`)
                            .setColor(0x0078ff)
                            .setTimestamp();
                        client.users.fetch(discord_id).then((user) => {
                            user.send({ embeds: [dmEmbed] })
                                .then(() => {
                                    const SuccessEmbed = new EmbedBuilder()
                                        .setTitle('Corrupt Community Ban')
                                        .setDescription(`Successfully banned <@${discord_id}> from the server and all Discord servers.\n\n**${serversbanned.join('\n')}**`)
                                        .setColor(0x0078ff)
                                        .setFooter({text: `DM Sent`})
                                        .setTimestamp();
                                    interaction.editReply({ embeds: [SuccessEmbed], components: [] });
                                })
                                .catch(() => {
                                    const SuccessEmbed = new EmbedBuilder()
                                        .setTitle('Corrupt Community Ban')
                                        .setDescription(`Successfully banned <@${discord_id}> from the server and all Discord servers.\n\n**${serversbanned.join('\n')}**`)
                                        .setColor(0x0078ff)
                                        .setFooter({text: `Unable To Send DM`})
                                        .setTimestamp();
                                    interaction.editReply({ embeds: [SuccessEmbed], components: [] });
                                });
                        }).catch(() => {
                            const SuccessEmbed = new EmbedBuilder()
                                .setTitle('Corrupt Community Ban')
                                .setDescription(`Successfully banned <@${discord_id}> from the server and all Discord servers.\n\n**${serversbanned.join('\n')}**`)
                                .setColor(0x0078ff)
                                .setFooter({text: `Unable To Send DM`})
                                .setTimestamp();
                            interaction.editReply({ embeds: [SuccessEmbed], components: [] });
                        });
                        // Log the ban in Discord channel
                        const discordlogembed = new EmbedBuilder()
                            .setTitle('Corrupt Community Ban')
                            .setDescription(`**User:** <@${discord_id}>\n**Admin:** ${interaction.user}\n\n${serversbanned.join('\n')}`)
                            .setColor(0x0078ff)
                            .setTimestamp();
                        client.channels.cache.get('1205925107055460434').send({ embeds: [discordlogembed] });
                    } else if (i.customId === 'cancel_ban') {
                        const CancelEmbed = new EmbedBuilder()
                            .setTitle('Corrupt Community Ban')
                            .setDescription(`Ban operation canceled by ${interaction.user}.`)
                            .setColor(0xFFA500)
                            .setFooter({text: `Ban Has Been Canceled`})
                            .setTimestamp();
                        interaction.editReply({ embeds: [CancelEmbed], components: [] });
                    }
                });

                collector.on('end', async () => {
                    if (message && !message.deleted) {
                        await message.edit({ components: [] });
                    }
                });
            } else {
                const ErrorEmbed = new EmbedBuilder()
                    .setTitle('Corrupt Community Ban')
                    .setDescription(`Unable to find user with Perm ID: **${permid}**`)
                    .setColor(0xff0000)
                    .setTimestamp();
                interaction.reply({ embeds: [ErrorEmbed], ephemeral: true });
            }
        });
    },
};
