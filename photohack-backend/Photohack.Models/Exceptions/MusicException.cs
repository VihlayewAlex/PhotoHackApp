using System;
using System.Collections.Generic;

namespace Photohack.Models
{
    /// <summary>
    /// Music exception.
    /// </summary>
    /// <seealso cref="System.Exception" />
    public class MusicException : Exception
    {
        /// <summary>
        /// The unexpected error
        /// </summary>
        private const string Unexpected = "Unexpected error.";

        /// <summary>
        /// Mapping the error codes to the default error messages.
        /// </summary>
        private static Dictionary<MusicErrorCode, string> errorCodeToMessage = new Dictionary<MusicErrorCode, string>
        {
            { MusicErrorCode.NullArgument, "Oops... Please, tell me at least phrase or words" },
            { MusicErrorCode.NothingFound, "I couldn't find anything:(" }
        };

        /// <summary>
        /// Initializes a new instance of the <see cref="MusicException"/> class.
        /// </summary>
        /// <param name="errorCode">The error code.</param>
        public MusicException(MusicErrorCode errorCode)
            : base(GetErrorMessage(errorCode))
        {
            this.ErrorCode = errorCode;
        }

        /// <summary>
        /// Gets the error code.
        /// </summary>
        /// <value>
        /// The error code.
        /// </value>
        public MusicErrorCode ErrorCode { get; private set; }

        /// <summary>
        /// Gets the error message.
        /// </summary>
        /// <param name="errorCode">The error code.</param>
        /// <returns>
        /// The error message text.
        /// </returns>
        private static string GetErrorMessage(MusicErrorCode errorCode)
        {
            string message = errorCodeToMessage.ContainsKey(errorCode)
                ? errorCodeToMessage[errorCode] : Unexpected;

            return message;
        }
    }
}
