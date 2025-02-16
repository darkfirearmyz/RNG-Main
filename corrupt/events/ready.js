const config = require("../settings.js");
const { REST } = require("@discordjs/rest");
const { Routes } = require("discord-api-types/v10");
const paramsjson = require(resourcePath + '/params.json');

module.exports = async (client) => {
    console.log(`[CORRUPT] ^2Discord Bot Successfully Loaded^0`);
    const verifychannelid = client.channels.cache.get("1340522589071736908");
    const verifyembed = new EmbedBuilder()
        .setTitle('RNG VERIFCATION')
        .setDescription('Connect to RNG to recive your 6 digit code in order to verify your account. Once you have your code, click the button below to verify your account.')
        .setColor(0xff0000)
        .setTimestamp();
    let verifybutton = new ActionRowBuilder()
        .addComponents(
            new ButtonBuilder()
                .setLabel('Verify')
                .setStyle(4)
                .setCustomId('verify')
        );
    verifychannelid.messages.fetch(paramsjson.verifyMessageID).then((msg) => {
        msg.edit({ embeds: [verifyembed], components: [verifybutton] });
    }).catch(err => {
        verifychannelid.send({ embeds: [verifyembed], components: [verifybutton] }).then((msg) => {
            paramsjson.verifyMessageID = msg.id;
            fs.writeFileSync(resourcePath + '/params.json', JSON.stringify(paramsjson));
        });
    });

    const rest = new REST({
        version: "10"
    }).setToken(config.settings.token);

    (async () => {
        try {
            await rest.put(Routes.applicationCommands(client.user.id), {
                body: await client.commands,
            });
        } catch (e) {
            console.log("Failed to load application [/] commands. " + e);
        }
    })();
}
