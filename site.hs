{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

import Data.Maybe (fromMaybe, listToMaybe)
import qualified Data.Text as T
import Hakyll
import System.FilePath (takeBaseName)
import System.Process (readProcess)
import Text.Pandoc.Definition (Block (CodeBlock, RawBlock), Pandoc)
import Text.Pandoc.Options
import Text.Pandoc.Walk (walk, walkM)

--------------------------------------------------------------------------------
--- `main` Entrypoint
--------------------------------------------------------------------------------

main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route idRoute
        compile copyFileCompiler

    scssDependency <- makePatternDependency "css/*.scss"
    rulesExtraDependencies [scssDependency] $
        match "css/style.scss" $ do
            route $ setExtension "css"
            compile sass

    match "js/*" $ do
        route idRoute
        compile copyFileCompiler

    match "*.md" $ do
        route $ setExtension "html"
        compile $ do
            pageName <- takeBaseName . toFilePath <$> getUnderlying
            let pageKey = "page-" <> pageName
            let pageContext = constField pageKey "" <> defaultContext

            customPandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" pageContext
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

    version "redirects" $ createRedirects queryLinks

--------------------------------------------------------------------------------
-- Stable SPARQL query links
--------------------------------------------------------------------------------

queryLinks =
    [
      ("example-1.html", "https://github.com/dozed/test/wiki/SPARQL-Queries#creator-types-in-dblp-run"),
      ("example-2.html", "https://github.com/dozed/test/wiki/SPARQL-Queries#most-cited-publications-with-title-keyword-dblp-run")
    ]

--------------------------------------------------------------------------------
-- Pandoc + pygmentize
--------------------------------------------------------------------------------

customPandocCompiler :: Compiler (Item String)
customPandocCompiler =
    pandocCompilerWithTransformM
        defaultHakyllReaderOptions
        defaultHakyllWriterOptions
        pygmentsHighlight

pygmentsHighlight :: Pandoc -> Compiler Pandoc
pygmentsHighlight = walkM \case
    CodeBlock (_, (T.unpack -> lang) : _, _) (T.unpack -> body) ->
        RawBlock "html" . T.pack <$> unsafeCompiler (callPygs lang body)
    block -> pure block
  where
    callPygs :: String -> String -> IO String
    callPygs lang = readProcess "pygmentize" ["-l", lang, "-f", "html"]

--------------------------------------------------------------------------------
-- SASS
--------------------------------------------------------------------------------

sass :: Compiler (Item String)
sass =
    getResourceString
        -- >>= withItemBody (unixFilter "sass" ["-s", "compressed", "--stdin", "--load-path=./css"])
        >>= withItemBody (unixFilter "sass" ["--stdin", "--style=expanded", "--load-path=./css"])
        >>= return . fmap compressCss
