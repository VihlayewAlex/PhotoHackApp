using System;
using System.Collections.Generic;

namespace Photohack.Models
{
    /// <summary>
    /// Emotion exception.
    /// </summary>
    /// <seealso cref="System.Exception" />
    public class EmotionException : Exception
    {
        /// <summary>
        /// The unexpected error
        /// </summary>
        private const string Unexpected = "Unexpected error.";

        /// <summary>
        /// Mapping the error codes to the default error messages.
        /// </summary>
        private static Dictionary<EmotionErrorCode, string> errorCodeToMessage = new Dictionary<EmotionErrorCode, string>
        {
            { EmotionErrorCode.NullArgument, "Oops... Please, tell me something:)" },
            { EmotionErrorCode.NothingFound, "I couldn't find anything:(" }
        };

        /// <summary>
        /// Initializes a new instance of the <see cref="EmotionException"/> class.
        /// </summary>
        /// <param name="errorCode">The error code.</param>
        public EmotionException(EmotionErrorCode errorCode)
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
        public EmotionErrorCode ErrorCode { get; private set; }

        /// <summary>
        /// Gets the error message.
        /// </summary>
        /// <param name="errorCode">The error code.</param>
        /// <returns>
        /// The error message text.
        /// </returns>
        private static string GetErrorMessage(EmotionErrorCode errorCode)
        {
            string message = errorCodeToMessage.ContainsKey(errorCode)
                ? errorCodeToMessage[errorCode] : Unexpected;

            return message;
        }
    }
}
