package subcommand

import (
	"github.com/spf13/cobra"
)

func newLastWeekCommand() *cobra.Command {
	me := &cobra.Command{
		Use: "lastweek",
		Short: "先週分のtogglエントリのサマリを出力する",
		Long:  `先週分のtogglエントリのサマリを出力する`,
		RunE: lastWeekCommand,
		SilenceUsage: true,
		SilenceErrors: true,
	}
	me.Flags().BoolVarP(&supressDetail, "supressDetail", "s", false, "詳細出力を抑制")
	return me
}

func lastWeekCommand(cmd *cobra.Command, args []string) (err error) {
	tglCl, err := readConfig()
	if err != nil { return err }

	from := tglCl.StartDayOfLastWeek()
	till := tglCl.After24Hours(from, 7)

	return tglCl.ProcessWeek(from, till, cmd.OutOrStdout(), !supressDetail)
}