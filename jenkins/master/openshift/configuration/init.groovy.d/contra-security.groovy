import java.util.logging.Logger
import com.redhat.jenkins.plugins.ci.*
import com.redhat.jenkins.plugins.ci.messaging.*
import hudson.markup.RawHtmlMarkupFormatter
import hudson.model.*
import hudson.security.*
import jenkins.model.*
import jenkins.security.s2m.*


def logger = Logger.getLogger("")
def jenkins = Jenkins.getInstance()

try {
    logger.info("Disabling CLI over remoting")
    jenkins.CLI.get().setEnabled(false);
} catch (err) {
    println "WARNING: Failed to disable CLI over remoting: ${err} (possible if Jenkins version > 2.164)"
}
logger.info("Enable Slave -> Master Access Control")
Jenkins.instance.injector.getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)
// Set global read permission
def strategy = Jenkins.instance.getAuthorizationStrategy()
strategy.add(hudson.model.Hudson.READ,'anonymous')
strategy.add(hudson.model.Item.READ,'anonymous')
// users with URL will be presented with login screen
strategy.add(hudson.model.Item.DISCOVER,'anonymous')
Jenkins.instance.setAuthorizationStrategy(strategy)
// Set Markup Formatter to Safe HTML so PR hyperlinks work
Jenkins.instance.setMarkupFormatter(new RawHtmlMarkupFormatter(false))

logger.info("Disabling deprecated agent protocols (only JNLP4 is enabled)")
Set<String> agentProtocolsList = ['JNLP4-connect']
Jenkins.instance.setAgentProtocols(agentProtocolsList)

Jenkins.instance.save()