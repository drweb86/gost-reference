using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;

namespace GostReferences.View
{
    class CopyStringCommand: CommandHandler
    {
        public CopyStringCommand()
            : base(CopyToClipboard, true)
        {
        }

        private static void CopyToClipboard(object argument)
        {
            if (argument != null &&
                argument is string &&
                !string.IsNullOrWhiteSpace((string) argument))
            {
                var typedArgument = (string) argument;

                for (int amountOfTries = 10; amountOfTries > 0; amountOfTries--)
                {
                    try
                    {
                        Clipboard.Clear();
                        Clipboard.SetText(typedArgument, TextDataFormat.UnicodeText);
                        break;
                    }
                    catch
                    {
                        System.Threading.Thread.Sleep(120);
                    }
                }
            }
        }
    }
}
